# == Schema Information
#
# Table name: university_person_involvements
#
#  id            :uuid             not null, primary key
#  description   :text
#  kind          :integer
#  position      :integer
#  target_type   :string           not null, indexed => [target_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  person_id     :uuid             not null, indexed
#  target_id     :uuid             not null, indexed => [target_type]
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_involvements_on_person_id      (person_id)
#  index_university_person_involvements_on_target         (target_type,target_id)
#  index_university_person_involvements_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_407e2a671c  (person_id => university_people.id)
#  fk_rails_5c704f6338  (university_id => universities.id)
#
class University::Person::Involvement < ApplicationRecord
  include Sanitizable
  include WithUniversity
  include WithPosition

  enum kind: { administrator: 10, researcher: 20, teacher: 30 }

  belongs_to :person, class_name: 'University::Person'
  belongs_to :target, polymorphic: true

  validates :person_id, uniqueness: { scope: [:target_id, :target_type] }
  validates :target_id, uniqueness: { scope: [:person_id, :target_type] }

  before_validation :set_kind, :set_university_id, on: :create
  before_validation :ensure_connected_elements_are_in_correct_language

  after_commit :sync_with_git

  scope :ordered_by_name, -> {
    joins(:person).select('university_person_involvements.*')
                  .order('university_people.last_name', 'university_people.first_name')
  }
  scope :ordered_by_date, -> { order(:created_at) }

  def to_s
    "#{person}"
  end

  def sync_with_git
    target.sync_with_git if target.respond_to? :sync_with_git
  end

  protected

  def last_ordered_element
    self.class.unscoped.where(university_id: university_id, target: target).ordered.last
  end

  def set_kind
    case target_type
    when "Education::Program"
      self.kind = :teacher
    when "Research::Laboratory"
      self.kind = :researcher
    else
      self.kind = :administrator
    end
  end

  def set_university_id
    self.university_id = self.person.university_id
  end

  def ensure_connected_elements_are_in_correct_language
    # Si on passe par un rôle, on veut s'assurer que la personne connectée soit de la même langue que le target
    # Si on passe par autre chose (connexion directe) on veut au contraire s'assurer que c'est le target qui a la même langue que la personne
    return unless person.language_id != target.language_id
    if target.is_a?(University::Role)
      person_in_correct_language = person.find_or_translate!(target.language)
      self.person_id = person_in_correct_language.id
    else
      target_in_correct_language = target.find_or_translate!(person.language)
      self.target_id = target_in_correct_language.id
    end
  end
end
