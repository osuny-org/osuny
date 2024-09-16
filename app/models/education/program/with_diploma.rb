module Education::Program::WithDiploma
  extend ActiveSupport::Concern

  included do
    belongs_to  :diploma,
                class_name: 'Education::Diploma',
                optional: true
  end

  # Used by website
  # https://github.com/noesya/osuny/issues/1529
  def diplomas
    Education::Diploma.where(id: diploma_id)
  end
end
