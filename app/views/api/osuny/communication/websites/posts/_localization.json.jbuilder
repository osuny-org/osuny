json.extract! l10n, :id, :migration_identifier, :title
json.featured_image do
  json.blob_id l10n.featured_image.blob_id
  json.alt l10n.featured_image_alt
  json.credit l10n.featured_image_credit
  json.url l10n.featured_image.url
end
json.extract! l10n, :meta_description, :pinned, :published, :published_at,
                    :slug, :subtitle, :summary, :text, :created_at, :updated_at