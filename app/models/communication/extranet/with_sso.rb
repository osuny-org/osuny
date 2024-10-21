module Communication::Extranet::WithSso
  extend ActiveSupport::Concern

  included do
    enum :sso_provider, { saml: 0 }, prefix: :with_sso_via

    validates :sso_cert, :sso_name_identifier_format, :sso_target_url, presence: true, if: :has_sso?
    validate :sso_mapping_should_have_email, if: :has_sso?
  end

  # Setter to serialize data as JSON
  def sso_mapping=(value)
    if value.blank?
      value = nil
    else
      value = JSON.parse value if value.is_a? String
    end
    super(value)
  end

  private

  def sso_mapping_should_have_email
    errors.add(:sso_mapping, :missing_email) unless (sso_mapping || []).detect { |sso_item| sso_item['internal_key'] == 'email' }
  end
end
