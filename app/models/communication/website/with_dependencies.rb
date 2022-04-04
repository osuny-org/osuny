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
    Communication::Block.where(about_type: 'Communication::Website::Page', about_id: pages)
  end

  def education_programs
    has_education_programs? ? about.programs : Education::Program.none
  end

  def research_volumes
    has_research_volumes? ? about.volumes : Research::Journal::Volume.none
  end

  def research_articles
    has_research_articles? ? about.articles : Research::Journal::Article.none
  end

  def people
    @people ||= begin
      people = []
      people += authors if has_authors?
      people += about.teachers if has_teachers?
      people += about.administrators if has_administrators?
      people += about.researchers if has_researchers?
      people.uniq.compact
    end
  end

  def people_with_facets
    @people_with_facets ||= begin
      people = []
      people += authors + authors.compact.map(&:author) if has_authors?
      people += about.teachers + about.teachers.map(&:teacher) if has_teachers?
      people += about.administrators + about.administrators.map(&:administrator) if has_administrators?
      people += about.researchers + about.researchers.map(&:researcher) if has_researchers?
      people.uniq.compact
    end
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

  def has_people?
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
