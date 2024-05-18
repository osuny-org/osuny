module Communication::Website::WithGitRepository
  extend ActiveSupport::Concern

  included do
    has_many  :website_git_files,
              class_name: 'Communication::Website::GitFile',
              dependent: :destroy
              alias_method :git_files, :website_git_files

    has_many  :website_git_file_orphans,
              foreign_key: :communication_website_id,
              class_name: 'Communication::Website::GitFile::Orphan',
              dependent: :destroy
              alias_method :git_file_orphans, :website_git_file_orphans

    has_many  :website_git_file_layouts,
              foreign_key: :communication_website_id,
              class_name: 'Communication::Website::GitFile::Layout',
              dependent: :destroy
              alias_method :git_file_layouts, :website_git_file_layouts

    after_save :destroy_obsolete_git_files, if: :should_clean_on_git?

    scope :with_repository, -> { where.not(repository: [nil, '']) }

  end

  def git_repository
    @git_repository ||= Git::Repository.new self
  end

  def repository_url
    git_repository.url
  end

  # Synchronisation optimale d'objet indirect
  def sync_indirect_object_with_git(indirect_object)
    Communication::Website::IndirectObject::SyncWithGitJob.perform_later(website, indirect_object)
  end

  def sync_indirect_object_with_git_safely(indirect_object)
    indirect_object.direct_sources.each do |direct_source|
      add_direct_source_to_sync(direct_source)
    end
    git_repository.sync!
  end

  # Supprimer tous les git_files qui ne sont pas dans les recursive_dependencies_syncable
  def destroy_obsolete_git_files
    Communication::Website::DestroyObsoleteGitFilesJob.perform_later(website.id)
  end

  def destroy_obsolete_git_files_safely
    website_git_files.find_each do |git_file|
      dependency = git_file.about
      # Here, dependency can be nil (object was previously destroyed)
      is_obsolete = dependency.nil? || !dependency.in?(recursive_dependencies_syncable_following_direct)
      if is_obsolete
        Communication::Website::GitFile.mark_for_destruction(self, git_file)
      end
    end
    git_repository.sync!
  end

  def invalidate_access_token!
    # Nullify the expired token
    update_column :access_token, nil
    # Notify admins and website managers managing this website.
    users_to_notify = university.users.admin + university.users.website_manager.where(id: manager_ids)
    users_to_notify.each do |user|
      NotificationMailer.website_invalid_access_token(self, user).deliver_later
    end
  end

  # Le website devient data/website.yml
  # Les configs héritent du modèle website et s'exportent en différents fichiers
  def exportable_to_git?
    true
  end

  def should_clean_on_git?
    # Clean website if about was present and changed OR a language was removed
    (saved_change_to_about_id? && about_id_before_last_save.present?) || language_was_removed
  end

  def update_theme_version
    Communication::Website::UpdateThemeVersionJob.perform_later(id)
  end

  def update_theme_version_safely
    git_repository.update_theme_version!
  end

  protected

  def add_direct_source_to_sync(direct_source)
    # Ne pas traiter les sources d'autres sites
    return unless direct_source.website.id == self.id
    # Ne pas traiter les sources non synchronisables
    return unless direct_source.syncable?
    Communication::Website::GitFile.sync self, direct_source
    direct_source.recursive_dependencies(syncable_only: true).each do |object|
      Communication::Website::GitFile.sync self, object
    end
    # On ne synchronise pas les références de l'objet direct, car on ne le modifie pas lui.
  end
end
