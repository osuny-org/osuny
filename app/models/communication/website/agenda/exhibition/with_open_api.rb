module Communication::Website::Agenda::Exhibition::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Agenda::Exhibition",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        from_day: { type: :string, format: "date" },
        to_day: { type: :string, format: "date" },
        time_zone: { type: :string },
        created_by_id: { type: :string, format: :uuid, nullable: true },
        localizations: {
          type: :object,
          description: "Localizations of the exhibitiojn. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_agenda_exhibition_localization"
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end
