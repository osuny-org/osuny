# == Schema Information
#
# Table name: research_journal_articles
#
#  id                         :uuid             not null, primary key
#  published_at               :datetime
#  text                       :text
#  title                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  research_journal_id        :uuid             not null
#  research_journal_volume_id :uuid
#  university_id              :uuid             not null
#
# Indexes
#
#  index_research_journal_articles_on_research_journal_id         (research_journal_id)
#  index_research_journal_articles_on_research_journal_volume_id  (research_journal_volume_id)
#  index_research_journal_articles_on_university_id               (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_journal_id => research_journals.id)
#  fk_rails_...  (research_journal_volume_id => research_journal_volumes.id)
#  fk_rails_...  (university_id => universities.id)
#
class Research::Journal::Article < ApplicationRecord
  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  belongs_to :volume, foreign_key: :research_journal_volume_id, optional: true

  after_save :publish_to_github

  def to_s
    "#{ title }"
  end

  protected

  def publish_to_github
    return if journal.website&.repository.blank?
    github = Github.new journal.website.access_token, journal.website.repository
    data = ApplicationController.render(
      template: 'admin/research/journal/articles/jekyll',
      layout: false,
      assigns: { article: self }
    )
    github.publish  local_directory: "tmp/articles",
                    local_file: "#{id}.md",
                    data: data,
                    remote_file: "_articles/#{id}.md",
                    commit_message: "Save volume #{ title }"
  end
end
