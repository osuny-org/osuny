module Communication::Website::WithDependencies
  extend ActiveSupport::Concern

  included do

    has_many    :pages,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :menus,
                class_name: 'Communication::Website::Menu',
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :posts,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :authors, -> { distinct }, through: :posts

    has_many    :categories,
                class_name: 'Communication::Website::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

  end

  def blocks
    @blocks ||= Communication::Block.where(about_type: 'Communication::Website::Page', about_id: pages)
  end

  def blocks_dependencies
    blocks_dependencies ||= blocks.collect(&:git_dependencies).flatten.compact.uniq
  end

  def education_programs
    has_education_programs? ? about.published_programs : Education::Program.none
  end

  def research_volumes
    has_research_volumes? ? about.published_volumes : Research::Journal::Volume.none
  end

  def research_articles
    has_research_articles? ? about.published_articles : Research::Journal::Article.none
  end

  def administrators
    about.administrators
  end

  def researchers
    about.researchers
  end

  def teachers
    about.teachers
  end

  def people_in_blocks
    blocks_dependencies.reject { |dependency| !dependency.is_a? University::Person }
  end

  def people_with_facets_in_blocks
    blocks_dependencies.reject { |dependency| !dependency.class.to_s.start_with?('University::Person') }
  end

  def people
    @people ||= begin
      people = []
      people += authors if has_authors?
      people += teachers if has_teachers?
      people += administrators if has_administrators?
      people += researchers if has_researchers?
      people += people_in_blocks if has_people_in_blocks?
      people.uniq.compact
    end
  end

  def people_with_facets
    @people_with_facets ||= begin
      people_with_facets = people
      people_with_facets += authors.compact.map(&:author) if has_authors?
      people_with_facets += teachers.compact.map(&:teacher) if has_teachers?
      people_with_facets += administrators.compact.map(&:administrator) if has_administrators?
      people_with_facets += researchers.compact.map(&:researcher) if has_researchers?
      people_with_facets += people_with_facets_in_blocks if has_people_in_blocks?
      people_with_facets.uniq.compact
    end
  end

  # those tests has_xxx? should match the special page kind
  def has_home?
    true
  end

  def has_legal_terms?
    true
  end

  def has_sitemap?
    true
  end

  def has_privacy_policy?
    true
  end

  def has_communication_posts?
    posts.published.any?
  end

  def has_communication_categories?
    categories.any?
  end

  def has_authors?
    authors.compact.any?
  end

  def has_people_in_blocks?
    people_in_blocks.compact.any?
  end

  def has_persons?
    has_authors? || has_administrators? || has_researchers? || has_teachers?
  end

  def has_administrators?
    about && about.has_administrators?
  end

  def has_researchers?
    about && about.has_researchers?
  end

  def has_teachers?
    about && about.has_teachers?
  end

  def has_education_programs?
    about && about.has_education_programs?
  end

  def has_research_articles?
    about && about.has_research_articles?
  end

  def has_research_volumes?
    about && about.has_research_volumes?
  end

end
