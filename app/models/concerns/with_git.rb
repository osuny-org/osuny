module WithGit
  extend ActiveSupport::Concern

  included do
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about,
              dependent: :destroy
  end

  def git_path(website)
    raise NotImplementedError
  end

  def save_and_sync
    if save
      sync_with_git
      true
    else
      false
    end
  end

  def update_and_sync(params)
    if update(params)
      sync_with_git
      true
    else
      false
    end
  end

  def destroy_and_sync
    destroy_from_git
    destroy
  end

  def sync_with_git
    websites_for_self.each do |website|
      dependencies = git_dependencies(website).to_a.flatten.uniq.compact
      dependencies.each do |object|
        Communication::Website::GitFile.sync website, object
      end
      website.git_repository.sync!
    end
  end
  handle_asynchronously :sync_with_git, queue: 'default'

  def destroy_from_git
    websites_for_self.each do |website|
      dependencies = git_destroy_dependencies(website).to_a.flatten.uniq.compact
      dependencies.each do |object|
        Communication::Website::GitFile.sync website, object, destroy: true
      end
      website.git_repository.sync!
    end
  end

  protected

  def websites_for_self
    if is_a? Communication::Website
      [self]
    elsif respond_to?(:websites)
      websites
    elsif respond_to?(:website)
      [website]
    else
      []
    end
  end

  def git_dependencies(website = nil)
    [self]
  end

  def git_destroy_dependencies(website = nil)
    [self]
  end
end
