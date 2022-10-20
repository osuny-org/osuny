module User::WithRegistrationContext
  extend ActiveSupport::Concern

  included do
    attr_accessor :registration_context

    validate :extranet_access, if: -> { registration_context.is_a?(Communication::Extranet) }

    private

    def extranet_access
      unless registration_context.alumni.where(email: email).any?
        if registration_context.registration_contact.present?
          errors.add :email, I18n.t('extranet.errors.email_not_allowed_with_contact', contact: registration_context.registration_contact)
        else
          errors.add :email, I18n.t('extranet.errors.email_not_allowed')
        end
      end
    end

  end
end
