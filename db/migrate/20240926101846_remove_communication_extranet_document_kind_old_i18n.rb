class RemoveCommunicationExtranetDocumentKindOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_extranet_document_kinds, :slug
    remove_colum :communication_extranet_document_kinds, :name

  end
end
