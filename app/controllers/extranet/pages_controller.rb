class Extranet::PagesController < Extranet::ApplicationController
  skip_before_action :authenticate_user!, :authorize_extranet_access!
  before_action :load_extranet_localization, only: [:terms, :cookies_policy, :privacy_policy]

  def terms
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name('terms')
  end

  def cookies_policy
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name('cookies_policy')
  end

  def privacy_policy
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name('privacy_policy')
  end

  def data
    @metrics = []
    if current_extranet.has_feature?(:alumni)
      @metrics.concat [
        { value: current_extranet.alumni.count, name: University::Person::Alumnus.model_name.human(count: 2) },
        { value: current_extranet.academic_years.count, name: Education::AcademicYear.model_name.human(count: 2) },
        { value: current_extranet.cohorts.count, name: Education::Cohort.model_name.human(count: 2) },
        { value: current_extranet.about.university_person_alumni_organizations.count, name: University::Organization.model_name.human(count: 2) }
      ]
    end
    if current_extranet.has_feature?(:contacts)
      @metrics.concat [
        { value: current_extranet.connected_organizations.count, name: University::Organization.model_name.human(count: 2) }
      ]
    end
    if current_extranet.has_feature?(:alumni) || current_extranet.has_feature?(:contacts)
      @metrics.concat [
        { value: current_extranet.users.count, name: User.model_name.human(count: 2) },
        { value: current_extranet.experiences.count, name: University::Person::Experience.model_name.human(count: 2) },
      ]
    end
    breadcrumb
    add_breadcrumb t('extranet.data')
  end

  def load_extranet_localization
    @extranet_l10n = current_extranet.localization_for(current_language)
  end
end
