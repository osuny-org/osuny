module Communication::Website::Page::WithSpecialPage
  extend ActiveSupport::Concern

  included do

    # Types are listed in the order we want them to be created
    TYPES = [
      # Home always first
      Communication::Website::Page::Home,
      # Global objects
      Communication::Website::Page::CommunicationPost,
      Communication::Website::Page::CommunicationAgenda,
      Communication::Website::Page::CommunicationAgendaArchive,
      Communication::Website::Page::CommunicationAgendaExhibition,
      Communication::Website::Page::CommunicationAgendaExhibitionArchive,
      Communication::Website::Page::CommunicationPortfolio,
      Communication::Website::Page::Person,
      Communication::Website::Page::Organization,
      # Education
      Communication::Website::Page::EducationDiploma,
      Communication::Website::Page::EducationProgram,
      # Research
      Communication::Website::Page::ResearchVolume,
      Communication::Website::Page::ResearchPaper,
      Communication::Website::Page::ResearchPublication,
      # Administration
      Communication::Website::Page::AdministrationLocation,
      # People facets
      Communication::Website::Page::Administrator,
      Communication::Website::Page::Author,
      Communication::Website::Page::Researcher,
      Communication::Website::Page::Teacher,
      # Legal pages always at the end
      Communication::Website::Page::LegalTerm,
      Communication::Website::Page::PrivacyPolicy,
      Communication::Website::Page::Accessibility,
      Communication::Website::Page::Sitemap
    ]

    before_validation :initialize_special_page, on: :create, if: :is_special_page?
  end

  # Communication::Website::Page::CommunicationPosts -> communication_posts
  # Used for i18n
  def type_key
    type.demodulize.underscore
  end

  def is_home?
    type == 'Communication::Website::Page::Home'
  end

  def is_special_page?
    type.present?
  end

  def is_regular_page?
    type.blank?
  end

  def is_necessary_for_website?
    true
  end

  def is_listed_among_children?
    true
  end

  def editable_width?
    true
  end

  def full_width_by_default?
    false
  end

  def published_by_default?
    true
  end

  # Can it be unpublished?
  def draftable?
    true
  end

  # All special pages are undeletable
  def deletable?
    is_regular_page?
  end

  # Some pages need a specific Hugo layout
  def static_layout
    nil
  end

  def has_template_blocks?
    self.class.const_defined?('TEMPLATE_BLOCKS')
  end

  def default_menu_identifier
    'primary'
  end

  def generate_from_template(l10n)
    l10n.generate_blocks self.class::TEMPLATE_BLOCKS
  end

  def create_missing_localizations!
    l10n_created = false
    website.languages.each do |language|
      next if localized_in?(language)
      build_localization_for(language)
      l10n_created = true
    end
    save_and_sync if l10n_created
  end

  protected

  def default_parent
    website.special_page(Communication::Website::Page::Home)
  end

  def initialize_special_page
    # Set default attributes for special page
    self.parent = default_parent
    self.full_width = full_width_by_default?
    # Build the first localization of the page
    build_localization_for(website.default_language)
  end

  def build_localization_for(language)
    # Set default attributes for special page's localization
    i18n_key = "communication.website.pages.defaults.#{type_key}"
    localizations.build(
      language_id: language.id,
      title: I18n.t("#{i18n_key}.title", locale: language.iso_code),
      slug: I18n.t("#{i18n_key}.slug", locale: language.iso_code),
      published: published_by_default?
      # note: published_at will be set by WithPublication concern
    )
  end

end
