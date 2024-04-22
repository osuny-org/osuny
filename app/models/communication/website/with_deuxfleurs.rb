module Communication::Website::WithDeuxfleurs
  extend ActiveSupport::Concern

  included do
    before_save :deuxfleurs_golive, if: :deuxfleurs_hosting
    after_save :deuxfleurs_setup, if: :deuxfleurs_hosting
  end

  protected

  # 4 options:
  # 1. no deuxfleurs hosting at all -> do nothing
  # 2. no repo, deuxfleurs hosting : we need to create both
  # 3. repo exists, deuxfleurs hosting : only create deuxfleurs hosting
  # 4. both exists, deuxfleurs hosting needs to change identifier (Waiting for API possibility)
  def deuxfleurs_setup
    return unless deuxfleurs_hosting?
    if repository.blank?
      deuxfleurs_create_github_repository
      sleep 10
    end
    if deuxfleurs_identifier.blank?
      deuxfleurs_create_bucket
      sleep 10
      deuxfleurs_generate_certificate
      sleep 10
      save
    end
  end
  handle_asynchronously :deuxfleurs_setup, queue: :default

  def deuxfleurs_golive
    return unless in_production_changed? && in_production
    # https://www.test.com -> www.test.com
    new_identifier = URI(url).host
    if deuxfleurs.rename_bucket(self.deuxfleurs_identifier, new_identifier)
      self.deuxfleurs_identifier = new_identifier
    else
      errors.add :url
    end
  end

  def deuxfleurs_create_bucket
    deuxfleurs_identifier = deuxfleurs.create_bucket(deuxfleurs_default_identifier)
    update_columns  deuxfleurs_identifier: deuxfleurs_identifier,
                    url: deuxfleurs_default_url
  end

  def deuxfleurs_create_github_repository
    update_columns  access_token: ENV['GITHUB_ACCESS_TOKEN'],
                    repository: deuxfleurs_default_github_repository,
                    deployment_status_badge: deuxfleurs_default_badge_url
    git_repository.init_from_template(deuxfleurs_default_github_repository_name)
  end

  # cartographie.agit.osuny.site
  def deuxfleurs_default_identifier
    "#{to_s.parameterize}.#{university.identifier}.osuny.site"
  end

  # https://cartographie.agit.osuny.site
  def deuxfleurs_default_url
    "https://#{deuxfleurs_default_identifier}"
  end

  # agit-cartographie
  def deuxfleurs_default_github_repository_name
    "#{university.identifier}-#{to_s.parameterize}"
  end

  # noesya/agit-cartographie
  def deuxfleurs_default_github_repository
    "osunyorg/#{deuxfleurs_default_github_repository_name}"
  end

  def deuxfleurs_default_badge_url
    "https://github.com/#{deuxfleurs_default_github_repository}/actions/workflows/deuxfleurs.yml/badge.svg"
  end

  def deuxfleurs_generate_certificate
    Faraday.get url
  rescue
    # The certificate is not there yet, it is supposed to fail
    # This first call will generate it
  end

  def deuxfleurs
    @deuxfleurs ||= Deuxfleurs.new
  end
end