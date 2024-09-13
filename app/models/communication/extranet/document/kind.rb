# == Schema Information
#
# Table name: communication_extranet_document_kinds
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string           indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  extranet_document_kinds_universities                        (university_id)
#  index_communication_extranet_document_kinds_on_extranet_id  (extranet_id)
#  index_communication_extranet_document_kinds_on_slug         (slug)
#
# Foreign Keys
#
#  fk_rails_27a9b91ed8  (extranet_id => communication_extranets.id)
#  fk_rails_2a55cf899a  (university_id => universities.id)
#
class Communication::Extranet::Document::Kind < ApplicationRecord
  include Localizable
  include LocalizableOrderByNameScope
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'

  has_many :communication_extranet_documents, class_name: "Communication::Extranet::Document"
  alias_method :documents, :communication_extranet_documents

end
