# Donne la capacité de se synchroniser avec Git lors d'une opération ActiveRecord
# Utilisé par :
# - website
# - objets directs
module WithGit
  extend ActiveSupport::Concern

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

  def sync_with_git
    if website.locked_for_background_jobs?
      raise Communication::Website::LockedError.new("Website is locked for background jobs")
    else
      return unless should_sync_with_git?
      website.lock_for_background_jobs!
    end
    begin
      sync_with_git_safely
    ensure
      website.unlock_for_background_jobs!
    end
  end
  handle_asynchronously :sync_with_git, queue: :default

  protected

  def should_sync_with_git?
    website.git_repository.valid? && syncable?
  end

  def sync_with_git_safely
    Communication::Website::GitFile.sync website, self
    recursive_dependencies(syncable_only: true).each do |object|
      Communication::Website::GitFile.sync website, object
    end
    references.each do |object|
      Communication::Website::GitFile.sync website, object
    end
    website.git_repository.sync!
  end
end
