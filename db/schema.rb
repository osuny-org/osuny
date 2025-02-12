# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_02_12_124156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.uuid "university_id"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    t.index ["university_id"], name: "index_active_storage_blobs_on_university_id"
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administration_location_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address_additional"
    t.string "address_name"
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.string "meta_description"
    t.string "slug"
    t.text "summary"
    t.string "name"
    t.string "url"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_administration_location_localizations_on_about_id"
    t.index ["language_id"], name: "index_administration_location_localizations_on_language_id"
    t.index ["university_id"], name: "index_administration_location_localizations_on_university_id"
  end

  create_table "administration_locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_administration_locations_on_university_id"
  end

  create_table "administration_locations_education_programs", id: false, force: :cascade do |t|
    t.uuid "education_program_id", null: false
    t.uuid "administration_location_id", null: false
    t.index ["administration_location_id", "education_program_id"], name: "index_program_location"
    t.index ["education_program_id", "administration_location_id"], name: "index_location_program"
  end

  create_table "administration_locations_education_schools", id: false, force: :cascade do |t|
    t.uuid "education_school_id", null: false
    t.uuid "administration_location_id", null: false
    t.index ["administration_location_id", "education_school_id"], name: "index_school_location"
    t.index ["education_school_id", "administration_location_id"], name: "index_location_school"
  end

  create_table "administration_qualiopi_criterions", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number"
    t.text "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administration_qualiopi_indicators", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "criterion_id", null: false
    t.integer "number"
    t.text "name"
    t.text "level_expected"
    t.text "proof"
    t.text "requirement"
    t.text "non_conformity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "glossary"
    t.index ["criterion_id"], name: "index_administration_qualiopi_indicators_on_criterion_id"
  end

  create_table "communication_blocks", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.integer "template_kind", default: 0, null: false
    t.jsonb "data"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "published", default: true
    t.uuid "communication_website_id"
    t.string "migration_identifier"
    t.string "html_class"
    t.index ["about_type", "about_id"], name: "index_communication_website_blocks_on_about"
    t.index ["communication_website_id"], name: "index_communication_blocks_on_communication_website_id"
    t.index ["university_id"], name: "index_communication_blocks_on_university_id"
  end

  create_table "communication_extranet_connections", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "extranet_id", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_type", "about_id"], name: "index_communication_extranet_connections_on_object"
    t.index ["extranet_id"], name: "index_communication_extranet_connections_on_extranet_id"
    t.index ["university_id"], name: "index_communication_extranet_connections_on_university_id"
  end

  create_table "communication_extranet_document_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "extranet_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["extranet_id"], name: "index_communication_extranet_document_categories_on_extranet_id"
    t.index ["university_id"], name: "extranet_document_categories_universities"
  end

  create_table "communication_extranet_document_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "extranet_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_23f2406431"
    t.index ["extranet_id"], name: "idx_on_extranet_id_14250ebc96"
    t.index ["language_id"], name: "idx_on_language_id_97c91dbc2f"
    t.index ["university_id"], name: "idx_on_university_id_5fd0a2ba37"
  end

  create_table "communication_extranet_document_kind_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "extranet_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_0cd2750c0e"
    t.index ["extranet_id"], name: "idx_on_extranet_id_39af5dfd8e"
    t.index ["language_id"], name: "idx_on_language_id_a4b9bfa7ba"
    t.index ["university_id"], name: "idx_on_university_id_0dc1259072"
  end

  create_table "communication_extranet_document_kinds", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "extranet_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["extranet_id"], name: "index_communication_extranet_document_kinds_on_extranet_id"
    t.index ["university_id"], name: "extranet_document_kinds_universities"
  end

  create_table "communication_extranet_document_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "extranet_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_48b91d67ca"
    t.index ["extranet_id"], name: "idx_on_extranet_id_9e28b52a7e"
    t.index ["language_id"], name: "idx_on_language_id_c5a1e8c320"
    t.index ["university_id"], name: "idx_on_university_id_95419f1df4"
  end

  create_table "communication_extranet_documents", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "extranet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "kind_id"
    t.uuid "category_id"
    t.index ["category_id"], name: "extranet_document_categories"
    t.index ["extranet_id"], name: "index_communication_extranet_documents_on_extranet_id"
    t.index ["kind_id"], name: "index_extranet_document_kinds"
    t.index ["university_id"], name: "index_communication_extranet_documents_on_university_id"
  end

  create_table "communication_extranet_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "cookies_policy"
    t.text "home_sentence"
    t.string "name"
    t.text "privacy_policy"
    t.string "registration_contact"
    t.string "sso_button_label"
    t.text "terms"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "invitation_message_subject", default: ""
    t.text "invitation_message_text", default: ""
    t.index ["about_id"], name: "index_communication_extranet_localizations_on_about_id"
    t.index ["language_id"], name: "index_communication_extranet_localizations_on_language_id"
    t.index ["university_id"], name: "index_communication_extranet_localizations_on_university_id"
  end

  create_table "communication_extranet_post_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "extranet_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["extranet_id"], name: "index_communication_extranet_post_categories_on_extranet_id"
    t.index ["university_id"], name: "index_communication_extranet_post_categories_on_university_id"
  end

  create_table "communication_extranet_post_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "extranet_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_ff80179dbe"
    t.index ["extranet_id"], name: "idx_on_extranet_id_aeb5898555"
    t.index ["language_id"], name: "idx_on_language_id_87a464170d"
    t.index ["university_id"], name: "idx_on_university_id_1b84e09ad5"
  end

  create_table "communication_extranet_post_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.boolean "published", default: false
    t.boolean "pinned", default: false
    t.datetime "published_at"
    t.string "slug"
    t.text "summary"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "extranet_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_communication_extranet_post_localizations_on_about_id"
    t.index ["extranet_id"], name: "index_communication_extranet_post_localizations_on_extranet_id"
    t.index ["language_id"], name: "index_communication_extranet_post_localizations_on_language_id"
    t.index ["university_id"], name: "idx_on_university_id_28188e2217"
  end

  create_table "communication_extranet_posts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id"
    t.uuid "extranet_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "category_id"
    t.index ["author_id"], name: "index_communication_extranet_posts_on_author_id"
    t.index ["category_id"], name: "index_communication_extranet_posts_on_category_id"
    t.index ["extranet_id"], name: "index_communication_extranet_posts_on_extranet_id"
    t.index ["university_id"], name: "index_communication_extranet_posts_on_university_id"
  end

  create_table "communication_extranets", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "host"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.boolean "has_sso", default: false
    t.text "sso_cert"
    t.jsonb "sso_mapping"
    t.string "sso_name_identifier_format"
    t.integer "sso_provider", default: 0
    t.string "sso_target_url"
    t.string "color"
    t.boolean "feature_alumni", default: false
    t.boolean "feature_contacts", default: false
    t.boolean "feature_documents", default: false
    t.boolean "feature_posts", default: false
    t.boolean "feature_jobs", default: false
    t.text "sass"
    t.text "css"
    t.uuid "default_language_id", null: false
    t.text "upper_menu", default: ""
    t.index ["about_type", "about_id"], name: "index_communication_extranets_on_about"
    t.index ["default_language_id"], name: "index_communication_extranets_on_default_language_id"
    t.index ["university_id"], name: "index_communication_extranets_on_university_id"
  end

  create_table "communication_media_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "is_taxonomy", default: false
    t.integer "position", default: 0
    t.uuid "university_id", null: false
    t.uuid "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bodyclass"
    t.index ["parent_id"], name: "index_communication_media_categories_on_parent_id"
    t.index ["university_id"], name: "index_communication_media_categories_on_university_id"
  end

  create_table "communication_media_categories_medias", id: false, force: :cascade do |t|
    t.uuid "media_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id", "media_id"], name: "category_media"
    t.index ["media_id", "category_id"], name: "media_category"
  end

  create_table "communication_media_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.text "summary"
    t.text "meta_description"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_communication_media_category_localizations_on_about_id"
    t.index ["language_id"], name: "idx_on_language_id_b744f004d4"
    t.index ["university_id"], name: "idx_on_university_id_0e75cba3b7"
  end

  create_table "communication_media_collection_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.uuid "language_id", null: false
    t.uuid "about_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_communication_media_collection_localizations_on_about_id"
    t.index ["language_id"], name: "idx_on_language_id_bb72607fc6"
    t.index ["university_id"], name: "idx_on_university_id_8e25b8c926"
  end

  create_table "communication_media_collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_communication_media_collections_on_university_id"
  end

  create_table "communication_media_contexts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "communication_media_id", null: false
    t.uuid "active_storage_blob_id", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_type", "about_id"], name: "index_communication_media_contexts_on_about"
    t.index ["active_storage_blob_id"], name: "index_communication_media_contexts_on_active_storage_blob_id"
    t.index ["communication_media_id"], name: "index_communication_media_contexts_on_communication_media_id"
    t.index ["university_id"], name: "index_communication_media_contexts_on_university_id"
  end

  create_table "communication_media_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "alt"
    t.text "credit"
    t.uuid "language_id", null: false
    t.uuid "about_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "internal_description"
    t.index ["about_id"], name: "index_communication_media_localizations_on_about_id"
    t.index ["language_id"], name: "index_communication_media_localizations_on_language_id"
    t.index ["university_id"], name: "index_communication_media_localizations_on_university_id"
  end

  create_table "communication_medias", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "origin", default: 1, null: false
    t.string "original_filename"
    t.string "original_checksum"
    t.string "original_content_type"
    t.bigint "original_byte_size"
    t.uuid "original_blob_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "communication_media_collection_id"
    t.index ["communication_media_collection_id"], name: "idx_on_communication_media_collection_id_6cace98319"
    t.index ["original_blob_id"], name: "index_communication_medias_on_original_blob_id"
    t.index ["university_id"], name: "index_communication_medias_on_university_id"
  end

  create_table "communication_website_agenda_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "position"
    t.uuid "communication_website_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.boolean "is_programs_root", default: false
    t.uuid "program_id"
    t.boolean "is_taxonomy", default: false
    t.string "bodyclass"
    t.index ["communication_website_id"], name: "idx_communication_website_agenda_cats_on_website_id"
    t.index ["parent_id"], name: "index_communication_website_agenda_categories_on_parent_id"
    t.index ["program_id"], name: "index_communication_website_agenda_categories_on_program_id"
    t.index ["university_id"], name: "index_communication_website_agenda_categories_on_university_id"
  end

  create_table "communication_website_agenda_categories_events", id: false, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id", "event_id"], name: "category_event"
    t.index ["event_id", "category_id"], name: "event_category"
  end

  create_table "communication_website_agenda_categories_exhibitions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "category_id", null: false
    t.uuid "exhibition_id", null: false
    t.index ["category_id"], name: "idx_on_category_id_8612661ce8"
    t.index ["exhibition_id"], name: "idx_on_exhibition_id_462c88c523"
  end

  create_table "communication_website_agenda_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.string "name"
    t.string "path"
    t.string "slug"
    t.text "summary"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.uuid "communication_website_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_012efb471f"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_2eaea4d96e"
    t.index ["language_id"], name: "idx_on_language_id_8542c3d2f9"
    t.index ["slug"], name: "idx_on_slug_55ae2c29d7"
    t.index ["university_id"], name: "idx_on_university_id_934ff72e5e"
  end

  create_table "communication_website_agenda_event_days", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "language_id", null: false
    t.uuid "communication_website_id", null: false
    t.uuid "communication_website_agenda_event_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_website_agenda_event_id"], name: "idx_on_communication_website_agenda_event_id_4defccd002"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_38a3895ffa"
    t.index ["language_id"], name: "index_communication_website_agenda_event_days_on_language_id"
    t.index ["university_id"], name: "index_communication_website_agenda_event_days_on_university_id"
  end

  create_table "communication_website_agenda_event_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "add_to_calendar_urls"
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.string "meta_description"
    t.string "migration_identifier"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "slug"
    t.string "subtitle"
    t.text "summary"
    t.text "text"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "communication_website_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "header_cta", default: false
    t.string "header_cta_label"
    t.string "header_cta_url"
    t.index ["about_id"], name: "idx_on_about_id_db6323806a"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_87f393a516"
    t.index ["language_id"], name: "idx_on_language_id_c00e1d0218"
    t.index ["university_id"], name: "idx_on_university_id_eaf79b0514"
  end

  create_table "communication_website_agenda_event_time_slot_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.uuid "about_id", null: false
    t.bigint "language_id"
    t.integer "duration"
    t.string "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_e52a2e12b0"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_526f156fed"
    t.index ["language_id"], name: "idx_on_language_id_f50f565794"
    t.index ["university_id"], name: "idx_on_university_id_4dee92bcc5"
  end

  create_table "communication_website_agenda_event_time_slots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.uuid "communication_website_agenda_event_id", null: false
    t.datetime "datetime"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_website_agenda_event_id"], name: "idx_on_communication_website_agenda_event_id_022d825cf7"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_c0ac516bb5"
    t.index ["university_id"], name: "idx_on_university_id_bca328e63c"
  end

  create_table "communication_website_agenda_events", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.date "from_day"
    t.time "from_hour"
    t.date "to_day"
    t.time "to_hour"
    t.uuid "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone"
    t.string "migration_identifier"
    t.uuid "created_by_id"
    t.index ["communication_website_id"], name: "index_agenda_events_on_communication_website_id"
    t.index ["created_by_id"], name: "index_communication_website_agenda_events_on_created_by_id"
    t.index ["parent_id"], name: "index_communication_website_agenda_events_on_parent_id"
    t.index ["university_id"], name: "index_communication_website_agenda_events_on_university_id"
  end

  create_table "communication_website_agenda_exhibition_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "add_to_calendar_urls"
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.boolean "header_cta"
    t.string "header_cta_label"
    t.string "header_cta_url"
    t.string "meta_description"
    t.string "migration_identifier"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "slug"
    t.string "subtitle"
    t.text "summary"
    t.string "title"
    t.uuid "about_id", null: false
    t.uuid "language_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "communication_website_id", null: false
    t.index ["about_id"], name: "idx_on_about_id_a6e772a338"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_8261badeaa"
    t.index ["language_id"], name: "idx_on_language_id_a2de6ce8d0"
    t.index ["university_id"], name: "idx_on_university_id_64ba331f7d"
  end

  create_table "communication_website_agenda_exhibitions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.uuid "created_by_id"
    t.date "from_day"
    t.date "to_day"
    t.string "migration_identifier"
    t.string "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_website_id"], name: "index_agenda_exhibitions_on_communication_website_id"
    t.index ["created_by_id"], name: "idx_on_created_by_id_c3766f3a0a"
    t.index ["university_id"], name: "idx_on_university_id_46e895f493"
  end

  create_table "communication_website_connections", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.string "indirect_object_type", null: false
    t.uuid "indirect_object_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "direct_source_type"
    t.uuid "direct_source_id"
    t.index ["direct_source_type", "direct_source_id"], name: "index_communication_website_connections_on_source"
    t.index ["indirect_object_type", "indirect_object_id"], name: "index_communication_website_connections_on_object"
    t.index ["university_id"], name: "index_communication_website_connections_on_university_id"
    t.index ["website_id"], name: "index_communication_website_connections_on_website_id"
  end

  create_table "communication_website_git_file_layouts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path"
    t.uuid "communication_website_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_eb9ee4bc34"
    t.index ["university_id"], name: "index_communication_website_git_file_layouts_on_university_id"
  end

  create_table "communication_website_git_file_orphans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path"
    t.uuid "communication_website_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_18bd864000"
    t.index ["university_id"], name: "index_communication_website_git_file_orphans_on_university_id"
  end

  create_table "communication_website_git_files", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "previous_path"
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.uuid "website_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "previous_sha"
    t.index ["about_type", "about_id"], name: "index_communication_website_github_files_on_about"
    t.index ["website_id"], name: "index_communication_website_git_files_on_website_id"
  end

  create_table "communication_website_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "about_id", null: false
    t.uuid "language_id", null: false
    t.uuid "university_id", null: false
    t.string "name"
    t.string "social_email"
    t.string "social_mastodon"
    t.string "social_peertube"
    t.string "social_x"
    t.string "social_github"
    t.string "social_linkedin"
    t.string "social_youtube"
    t.string "social_vimeo"
    t.string "social_instagram"
    t.string "social_facebook"
    t.string "social_tiktok"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.index ["about_id"], name: "index_communication_website_localizations_on_about_id"
    t.index ["language_id"], name: "index_communication_website_localizations_on_language_id"
    t.index ["university_id"], name: "index_communication_website_localizations_on_university_id"
  end

  create_table "communication_website_menu_items", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.uuid "menu_id", null: false
    t.string "title"
    t.integer "position"
    t.integer "kind", default: 0
    t.uuid "parent_id"
    t.string "about_type"
    t.uuid "about_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "url"
    t.boolean "should_open_new_tab", default: false
    t.index ["about_type", "about_id"], name: "index_communication_website_menu_items_on_about"
    t.index ["menu_id"], name: "index_communication_website_menu_items_on_menu_id"
    t.index ["parent_id"], name: "index_communication_website_menu_items_on_parent_id"
    t.index ["university_id"], name: "index_communication_website_menu_items_on_university_id"
    t.index ["website_id"], name: "index_communication_website_menu_items_on_website_id"
  end

  create_table "communication_website_menus", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.string "title"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "original_id"
    t.uuid "language_id", null: false
    t.boolean "automatic", default: true
    t.index ["communication_website_id"], name: "idx_comm_website_menus_on_communication_website_id"
    t.index ["language_id"], name: "index_communication_website_menus_on_language_id"
    t.index ["original_id"], name: "index_communication_website_menus_on_original_id"
    t.index ["university_id"], name: "index_communication_website_menus_on_university_id"
  end

  create_table "communication_website_page_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "is_taxonomy", default: false
    t.integer "position"
    t.uuid "communication_website_id", null: false
    t.uuid "parent_id"
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "migration_identifier"
    t.uuid "program_id"
    t.boolean "is_programs_root", default: false
    t.string "bodyclass"
    t.index ["communication_website_id"], name: "idx_communication_website_page_cats_on_website_id"
    t.index ["parent_id"], name: "index_communication_website_page_categories_on_parent_id"
    t.index ["program_id"], name: "index_communication_website_page_categories_on_program_id"
    t.index ["university_id"], name: "index_communication_website_page_categories_on_university_id"
  end

  create_table "communication_website_page_categories_pages", id: false, force: :cascade do |t|
    t.uuid "page_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id", "page_id"], name: "idx_on_category_id_page_id_297597f98e"
    t.index ["page_id", "category_id"], name: "idx_on_page_id_category_id_c403d20e7a"
  end

  create_table "communication_website_page_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "path"
    t.text "meta_description"
    t.text "summary"
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "communication_website_id", null: false
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "migration_identifier"
    t.index ["about_id"], name: "idx_on_about_id_6c76163c36"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_f605face95"
    t.index ["language_id"], name: "idx_on_language_id_adc4ce8d8e"
    t.index ["university_id"], name: "idx_on_university_id_2237677b2f"
  end

  create_table "communication_website_page_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "breadcrumb_title"
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.boolean "header_cta"
    t.string "header_cta_label"
    t.string "header_cta_url"
    t.text "header_text"
    t.string "meta_description"
    t.string "migration_identifier"
    t.boolean "published"
    t.datetime "published_at"
    t.string "slug"
    t.text "summary"
    t.text "text"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "communication_website_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_communication_website_page_localizations_on_about_id"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_64c4831480"
    t.index ["language_id"], name: "index_communication_website_page_localizations_on_language_id"
    t.index ["university_id"], name: "idx_on_university_id_e62b2aba53"
  end

  create_table "communication_website_pages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.text "path"
    t.uuid "parent_id"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind"
    t.string "bodyclass"
    t.boolean "full_width", default: false
    t.string "type"
    t.string "migration_identifier"
    t.jsonb "design_options"
    t.index ["communication_website_id"], name: "index_communication_website_pages_on_communication_website_id"
    t.index ["parent_id"], name: "index_communication_website_pages_on_parent_id"
    t.index ["university_id"], name: "index_communication_website_pages_on_university_id"
  end

  create_table "communication_website_permalinks", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_current", default: true
    t.index ["about_type", "about_id"], name: "index_communication_website_permalinks_on_about"
    t.index ["university_id"], name: "index_communication_website_permalinks_on_university_id"
    t.index ["website_id"], name: "index_communication_website_permalinks_on_website_id"
  end

  create_table "communication_website_portfolio_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "is_programs_root", default: false
    t.integer "position"
    t.uuid "communication_website_id", null: false
    t.uuid "parent_id"
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_taxonomy", default: false
    t.uuid "program_id"
    t.string "bodyclass"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_8f309901d4"
    t.index ["parent_id"], name: "index_communication_website_portfolio_categories_on_parent_id"
    t.index ["program_id"], name: "index_communication_website_portfolio_categories_on_program_id"
    t.index ["university_id"], name: "idx_on_university_id_a07cc0a296"
  end

  create_table "communication_website_portfolio_categories_projects", id: false, force: :cascade do |t|
    t.uuid "category_id", null: false
    t.uuid "project_id", null: false
    t.index ["category_id", "project_id"], name: "idx_on_category_id_project_id_d3103b15e5"
    t.index ["project_id", "category_id"], name: "idx_on_project_id_category_id_8f020f7f60"
  end

  create_table "communication_website_portfolio_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.string "name"
    t.string "path"
    t.string "slug"
    t.text "summary"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "communication_website_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_e184bfe637"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_9d28ee55e4"
    t.index ["language_id"], name: "idx_on_language_id_70b50689c4"
    t.index ["university_id"], name: "idx_on_university_id_66e101bf70"
  end

  create_table "communication_website_portfolio_project_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.string "meta_description"
    t.string "migration_identifier"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "slug"
    t.text "summary"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "communication_website_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle"
    t.boolean "header_cta", default: false
    t.string "header_cta_label"
    t.string "header_cta_url"
    t.index ["about_id"], name: "idx_on_about_id_a668ef6090"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_e653b6273a"
    t.index ["language_id"], name: "idx_on_language_id_25a0c1e472"
    t.index ["university_id"], name: "idx_on_university_id_f01fc2c686"
  end

  create_table "communication_website_portfolio_projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "year"
    t.uuid "communication_website_id", null: false
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by_id"
    t.boolean "full_width", default: true
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_aac12e3adb"
    t.index ["created_by_id"], name: "idx_on_created_by_id_7009ee99c6"
    t.index ["university_id"], name: "idx_on_university_id_ac2f4a0bfc"
  end

  create_table "communication_website_post_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.uuid "program_id"
    t.boolean "is_programs_root", default: false
    t.boolean "is_taxonomy", default: false
    t.string "bodyclass"
    t.index ["communication_website_id"], name: "idx_communication_website_post_cats_on_communication_website_id"
    t.index ["parent_id"], name: "index_communication_website_post_categories_on_parent_id"
    t.index ["program_id"], name: "index_communication_website_post_categories_on_program_id"
    t.index ["university_id"], name: "index_communication_website_post_categories_on_university_id"
  end

  create_table "communication_website_post_categories_posts", id: false, force: :cascade do |t|
    t.uuid "post_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id", "post_id"], name: "category_post"
    t.index ["post_id", "category_id"], name: "post_category"
  end

  create_table "communication_website_post_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.string "name"
    t.text "meta_description"
    t.string "slug"
    t.string "path"
    t.text "summary"
    t.uuid "about_id"
    t.uuid "university_id", null: false
    t.uuid "language_id", null: false
    t.uuid "communication_website_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "idx_on_about_id_6e430d4efc"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_0c06c1ae6f"
    t.index ["language_id"], name: "idx_on_language_id_cc5f73e306"
    t.index ["university_id"], name: "idx_on_university_id_fb03a6e3c0"
  end

  create_table "communication_website_post_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.string "migration_identifier"
    t.boolean "pinned"
    t.boolean "published"
    t.datetime "published_at"
    t.string "slug"
    t.text "summary"
    t.text "text"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "communication_website_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle"
    t.boolean "header_cta", default: false
    t.string "header_cta_label"
    t.string "header_cta_url"
    t.index ["about_id"], name: "index_communication_website_post_localizations_on_about_id"
    t.index ["communication_website_id"], name: "idx_on_communication_website_id_f6354f61f0"
    t.index ["language_id"], name: "index_communication_website_post_localizations_on_language_id"
    t.index ["university_id"], name: "idx_on_university_id_a3a3f1e954"
  end

  create_table "communication_website_posts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "migration_identifier"
    t.boolean "full_width", default: false
    t.index ["communication_website_id"], name: "index_communication_website_posts_on_communication_website_id"
    t.index ["university_id"], name: "index_communication_website_posts_on_university_id"
  end

  create_table "communication_website_posts_university_people", id: false, force: :cascade do |t|
    t.uuid "communication_website_post_id", null: false
    t.uuid "university_person_id", null: false
    t.index ["communication_website_post_id", "university_person_id"], name: "post_person"
    t.index ["university_person_id", "communication_website_post_id"], name: "person_post"
  end

  create_table "communication_website_showcase_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communication_website_showcase_tags_websites", id: false, force: :cascade do |t|
    t.uuid "communication_website_id", null: false
    t.uuid "communication_website_showcase_tag_id", null: false
    t.index ["communication_website_id", "communication_website_showcase_tag_id"], name: "index_website_showcase_tag"
    t.index ["communication_website_showcase_tag_id", "communication_website_id"], name: "index_showcase_tag_website"
  end

  create_table "communication_websites", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.string "repository"
    t.string "about_type"
    t.uuid "about_id"
    t.integer "git_provider", default: 0
    t.string "git_endpoint"
    t.text "style"
    t.date "style_updated_at"
    t.string "plausible_url"
    t.string "git_branch"
    t.boolean "in_production", default: false
    t.uuid "default_language_id", null: false
    t.string "theme_version", default: "NA"
    t.text "deployment_status_badge"
    t.boolean "autoupdate_theme", default: true
    t.boolean "feature_posts", default: true
    t.boolean "feature_agenda", default: false
    t.boolean "deuxfleurs_hosting", default: true
    t.string "deuxfleurs_identifier"
    t.string "default_time_zone"
    t.boolean "feature_portfolio", default: false
    t.boolean "in_showcase", default: true
    t.datetime "locked_at"
    t.datetime "git_files_analysed_at"
    t.boolean "highlighted_in_showcase", default: false
    t.uuid "locked_by_job_id"
    t.string "deuxfleurs_access_key_id"
    t.string "deuxfleurs_secret_access_key"
    t.index ["about_type", "about_id"], name: "index_communication_websites_on_about"
    t.index ["default_language_id"], name: "index_communication_websites_on_default_language_id"
    t.index ["university_id"], name: "index_communication_websites_on_university_id"
  end

  create_table "communication_websites_languages", id: false, force: :cascade do |t|
    t.uuid "communication_website_id", null: false
    t.uuid "language_id", null: false
    t.index ["communication_website_id", "language_id"], name: "website_language"
  end

  create_table "communication_websites_users", id: false, force: :cascade do |t|
    t.uuid "communication_website_id", null: false
    t.uuid "user_id", null: false
    t.index ["communication_website_id", "user_id"], name: "website_user"
    t.index ["user_id", "communication_website_id"], name: "user_website"
  end

  create_table "education_academic_years", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_education_academic_years_on_university_id"
  end

  create_table "education_academic_years_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "education_academic_year_id", null: false
    t.index ["education_academic_year_id", "university_person_id"], name: "index_academic_year_person"
    t.index ["university_person_id", "education_academic_year_id"], name: "index_person_academic_year"
  end

  create_table "education_cohorts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "program_id", null: false
    t.uuid "academic_year_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "school_id", null: false
    t.index ["academic_year_id"], name: "index_education_cohorts_on_academic_year_id"
    t.index ["program_id"], name: "index_education_cohorts_on_program_id"
    t.index ["school_id"], name: "index_education_cohorts_on_school_id"
    t.index ["university_id"], name: "index_education_cohorts_on_university_id"
  end

  create_table "education_cohorts_university_people", id: false, force: :cascade do |t|
    t.uuid "education_cohort_id", null: false
    t.uuid "university_person_id", null: false
    t.index ["education_cohort_id", "university_person_id"], name: "index_cohort_person"
    t.index ["university_person_id", "education_cohort_id"], name: "index_person_cohort"
  end

  create_table "education_diploma_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "duration"
    t.string "name"
    t.string "short_name"
    t.string "slug"
    t.text "summary"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "pedagogy"
    t.text "evaluation"
    t.text "registration"
    t.text "prerequisites"
    t.text "other"
    t.text "pricing"
    t.text "pricing_initial"
    t.text "pricing_continuing"
    t.text "pricing_apprenticeship"
    t.text "accessibility"
    t.text "contacts"
    t.index ["about_id"], name: "index_education_diploma_localizations_on_about_id"
    t.index ["language_id"], name: "index_education_diploma_localizations_on_language_id"
    t.index ["university_id"], name: "index_education_diploma_localizations_on_university_id"
  end

  create_table "education_diplomas", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.integer "level", default: 0
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ects"
    t.string "certification"
    t.integer "position", default: 0
    t.index ["university_id"], name: "index_education_diplomas_on_university_id"
  end

  create_table "education_program_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "is_taxonomy", default: false
    t.integer "position"
    t.uuid "parent_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bodyclass"
    t.index ["parent_id"], name: "index_education_program_categories_on_parent_id"
    t.index ["university_id"], name: "index_education_program_categories_on_university_id"
  end

  create_table "education_program_categories_programs", id: false, force: :cascade do |t|
    t.uuid "program_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id", "program_id"], name: "category_program"
    t.index ["program_id", "category_id"], name: "program_category"
  end

  create_table "education_program_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.text "summary"
    t.index ["about_id"], name: "index_education_program_category_localizations_on_about_id"
    t.index ["language_id"], name: "index_education_program_category_localizations_on_language_id"
    t.index ["university_id"], name: "idx_on_university_id_833fd3c673"
  end

  create_table "education_program_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "accessibility"
    t.text "contacts"
    t.text "content"
    t.string "duration"
    t.text "evaluation"
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.string "name"
    t.text "objectives"
    t.text "opportunities"
    t.text "other"
    t.string "path"
    t.text "pedagogy"
    t.text "prerequisites"
    t.text "presentation"
    t.text "pricing"
    t.text "pricing_apprenticeship"
    t.text "pricing_continuing"
    t.text "pricing_initial"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.text "qualiopi_text"
    t.text "registration"
    t.string "registration_url"
    t.text "results"
    t.string "short_name"
    t.string "slug"
    t.text "summary"
    t.string "url"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_education_program_localizations_on_about_id"
    t.index ["language_id"], name: "index_education_program_localizations_on_language_id"
    t.index ["university_id"], name: "index_education_program_localizations_on_university_id"
  end

  create_table "education_programs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.integer "capacity"
    t.boolean "continuing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.uuid "diploma_id"
    t.boolean "initial"
    t.boolean "apprenticeship"
    t.string "bodyclass"
    t.boolean "qualiopi_certified", default: false
    t.index ["diploma_id"], name: "index_education_programs_on_diploma_id"
    t.index ["parent_id"], name: "index_education_programs_on_parent_id"
    t.index ["university_id"], name: "index_education_programs_on_university_id"
  end

  create_table "education_programs_schools", id: false, force: :cascade do |t|
    t.uuid "education_program_id", null: false
    t.uuid "education_school_id", null: false
    t.index ["education_program_id", "education_school_id"], name: "program_school"
    t.index ["education_school_id", "education_program_id"], name: "school_program"
  end

  create_table "education_programs_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "education_program_id", null: false
    t.index ["education_program_id", "university_person_id"], name: "index_program_person"
    t.index ["university_person_id", "education_program_id"], name: "index_person_program"
  end

  create_table "education_programs_users", id: false, force: :cascade do |t|
    t.uuid "education_program_id", null: false
    t.uuid "user_id", null: false
    t.index ["education_program_id", "user_id"], name: "index_education_programs_users_on_program_id_and_user_id"
  end

  create_table "education_school_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "slug"
    t.string "name"
    t.string "url"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_education_school_localizations_on_about_id"
    t.index ["language_id"], name: "index_education_school_localizations_on_language_id"
    t.index ["university_id"], name: "index_education_school_localizations_on_university_id"
  end

  create_table "education_schools", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.index ["university_id"], name: "index_education_schools_on_university_id"
  end

  create_table "emergency_messages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id"
    t.string "name"
    t.string "role"
    t.string "subject_fr"
    t.string "subject_en"
    t.text "content_fr"
    t.text "content_en"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "delivered_count"
    t.index ["university_id"], name: "index_emergency_messages_on_university_id", where: "(university_id IS NOT NULL)"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "imports", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number_of_lines"
    t.jsonb "processing_errors"
    t.integer "kind"
    t.integer "status", default: 0
    t.uuid "university_id", null: false
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "language_id", null: false
    t.index ["language_id"], name: "index_imports_on_language_id"
    t.index ["university_id"], name: "index_imports_on_university_id"
    t.index ["user_id"], name: "index_imports_on_user_id"
  end

  create_table "languages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summernote_locale"
  end

  create_table "languages_universities", id: false, force: :cascade do |t|
    t.uuid "language_id", null: false
    t.uuid "university_id", null: false
    t.index ["university_id", "language_id"], name: "index_languages_universities_on_university_id_and_language_id"
  end

  create_table "research_hal_authors", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "docid"
    t.string "form_identifier"
    t.string "person_identifier"
    t.string "first_name"
    t.string "last_name"
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docid"], name: "index_research_hal_authors_on_docid"
  end

  create_table "research_hal_authors_publications", id: false, force: :cascade do |t|
    t.uuid "research_publication_id", null: false
    t.uuid "research_hal_author_id", null: false
    t.index ["research_hal_author_id", "research_publication_id"], name: "hal_publication_author"
    t.index ["research_publication_id", "research_hal_author_id"], name: "hal_author_publication"
  end

  create_table "research_hal_authors_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "research_hal_author_id", null: false
    t.index ["research_hal_author_id", "university_person_id"], name: "hal_person_author"
    t.index ["university_person_id", "research_hal_author_id"], name: "hal_author_person"
  end

  create_table "research_journal_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "issn"
    t.text "meta_description"
    t.text "summary"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_journal_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_journal_localizations_on_language_id"
    t.index ["university_id"], name: "index_research_journal_localizations_on_university_id"
  end

  create_table "research_journal_paper_kind_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_journal_paper_kind_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_journal_paper_kind_localizations_on_language_id"
    t.index ["university_id"], name: "idx_on_university_id_dc9f1267b7"
  end

  create_table "research_journal_paper_kinds", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "journal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_id"], name: "index_research_journal_paper_kinds_on_journal_id"
    t.index ["university_id"], name: "index_research_journal_paper_kinds_on_university_id"
  end

  create_table "research_journal_paper_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "abstract"
    t.text "authors_list"
    t.text "keywords"
    t.text "meta_description"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "slug"
    t.text "summary"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_journal_paper_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_journal_paper_localizations_on_language_id"
    t.index ["university_id"], name: "index_research_journal_paper_localizations_on_university_id"
  end

  create_table "research_journal_papers", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_journal_id", null: false
    t.uuid "research_journal_volume_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by_id"
    t.text "bibliography"
    t.integer "position"
    t.text "text"
    t.uuid "kind_id"
    t.date "received_at"
    t.date "accepted_at"
    t.string "doi"
    t.index ["kind_id"], name: "index_research_journal_papers_on_kind_id"
    t.index ["research_journal_id"], name: "index_research_journal_papers_on_research_journal_id"
    t.index ["research_journal_volume_id"], name: "index_research_journal_papers_on_research_journal_volume_id"
    t.index ["university_id"], name: "index_research_journal_papers_on_university_id"
    t.index ["updated_by_id"], name: "index_research_journal_papers_on_updated_by_id"
  end

  create_table "research_journal_papers_researchers", force: :cascade do |t|
    t.uuid "researcher_id", null: false
    t.uuid "paper_id", null: false
    t.index ["paper_id"], name: "index_research_journal_papers_researchers_on_paper_id"
    t.index ["researcher_id"], name: "index_research_journal_papers_researchers_on_researcher_id"
  end

  create_table "research_journal_volume_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.text "keywords"
    t.text "meta_description"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "slug"
    t.text "summary"
    t.text "text"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_journal_volume_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_journal_volume_localizations_on_language_id"
    t.index ["university_id"], name: "index_research_journal_volume_localizations_on_university_id"
  end

  create_table "research_journal_volumes", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_journal_id", null: false
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["research_journal_id"], name: "index_research_journal_volumes_on_research_journal_id"
    t.index ["university_id"], name: "index_research_journal_volumes_on_university_id"
  end

  create_table "research_journals", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_research_journals_on_university_id"
  end

  create_table "research_laboratories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_research_laboratories_on_university_id"
  end

  create_table "research_laboratories_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "research_laboratory_id", null: false
    t.index ["research_laboratory_id", "university_person_id"], name: "person_laboratory"
    t.index ["university_person_id", "research_laboratory_id"], name: "laboratory_person"
  end

  create_table "research_laboratory_axes", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_laboratory_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["research_laboratory_id"], name: "index_research_laboratory_axes_on_research_laboratory_id"
    t.index ["university_id"], name: "index_research_laboratory_axes_on_university_id"
  end

  create_table "research_laboratory_axis_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "meta_description"
    t.string "name"
    t.string "short_name"
    t.text "summary"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_laboratory_axis_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_laboratory_axis_localizations_on_language_id"
    t.index ["university_id"], name: "index_research_laboratory_axis_localizations_on_university_id"
  end

  create_table "research_laboratory_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address_additional"
    t.string "address_name"
    t.string "name"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_laboratory_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_laboratory_localizations_on_language_id"
    t.index ["university_id"], name: "index_research_laboratory_localizations_on_university_id"
  end

  create_table "research_publications", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "hal_docid"
    t.jsonb "data"
    t.string "title"
    t.string "url"
    t.string "ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hal_url"
    t.date "publication_date"
    t.string "doi"
    t.string "slug"
    t.text "citation_full"
    t.boolean "open_access"
    t.text "abstract"
    t.string "journal_title"
    t.text "file"
    t.text "authors_list"
    t.json "authors_citeproc"
    t.integer "source", default: 0
    t.index ["hal_docid"], name: "index_research_publications_on_hal_docid"
    t.index ["slug"], name: "index_research_publications_on_slug"
  end

  create_table "research_publications_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "research_publication_id", null: false
    t.index ["research_publication_id", "university_person_id"], name: "index_person_publication"
    t.index ["university_person_id", "research_publication_id"], name: "index_publication_person"
  end

  create_table "research_theses", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_laboratory_id", null: false
    t.uuid "author_id", null: false
    t.uuid "director_id", null: false
    t.date "started_at"
    t.boolean "completed", default: false
    t.date "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_research_theses_on_author_id"
    t.index ["director_id"], name: "index_research_theses_on_director_id"
    t.index ["research_laboratory_id"], name: "index_research_theses_on_research_laboratory_id"
    t.index ["university_id"], name: "index_research_theses_on_university_id"
  end

  create_table "research_thesis_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "abstract"
    t.string "title"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_research_thesis_localizations_on_about_id"
    t.index ["language_id"], name: "index_research_thesis_localizations_on_language_id"
    t.index ["university_id"], name: "index_research_thesis_localizations_on_university_id"
  end

  create_table "search_index", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "title"
    t.text "text"
    t.uuid "language_id", null: false
    t.string "about_object_type", null: false
    t.uuid "about_object_id", null: false
    t.string "about_localization_type", null: false
    t.uuid "about_localization_id", null: false
    t.uuid "website_id"
    t.uuid "extranet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_localization_type", "about_localization_id"], name: "index_search_on_about_localization"
    t.index ["about_object_type", "about_object_id"], name: "index_search_on_about_object"
    t.index ["extranet_id"], name: "index_search_index_on_extranet_id"
    t.index ["language_id"], name: "index_search_index_on_language_id"
    t.index ["university_id"], name: "index_search_index_on_university_id"
    t.index ["website_id"], name: "index_search_index_on_website_id"
  end

  create_table "universities", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.boolean "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mail_from_name"
    t.string "mail_from_address"
    t.string "sms_sender_name"
    t.date "invoice_date"
    t.integer "invoice_date_yday"
    t.boolean "has_sso", default: false
    t.integer "sso_provider", default: 0
    t.string "sso_target_url"
    t.text "sso_cert"
    t.string "sso_name_identifier_format"
    t.jsonb "sso_mapping"
    t.string "sso_button_label"
    t.uuid "default_language_id", null: false
    t.boolean "is_really_a_university", default: true
    t.float "contribution_amount"
    t.string "default_github_access_token"
    t.index ["default_language_id"], name: "index_universities_on_default_language_id"
    t.index ["name"], name: "index_universities_on_name", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "university_apps", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "university_id", null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "token_was_displayed", default: false
    t.index ["token"], name: "index_university_apps_on_token", unique: true
    t.index ["university_id"], name: "index_university_apps_on_university_id"
  end

  create_table "university_organization_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.integer "position", default: 0
    t.boolean "is_taxonomy", default: false
    t.string "migration_identifier"
    t.string "bodyclass"
    t.index ["parent_id"], name: "index_university_organization_categories_on_parent_id"
    t.index ["university_id"], name: "index_university_organization_categories_on_university_id"
  end

  create_table "university_organization_categories_organizations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id"], name: "idx_on_category_id_7494b991ff"
    t.index ["organization_id"], name: "idx_on_organization_id_7e5c9e451b"
  end

  create_table "university_organization_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.text "summary"
    t.string "migration_identifier"
    t.index ["about_id"], name: "idx_on_about_id_f5fce0a0b7"
    t.index ["language_id"], name: "idx_on_language_id_8e479f2339"
    t.index ["slug"], name: "index_university_organization_category_localizations_on_slug"
    t.index ["university_id"], name: "idx_on_university_id_2aaf668550"
  end

  create_table "university_organization_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address_additional"
    t.string "address_name"
    t.string "linkedin"
    t.string "long_name"
    t.string "mastodon"
    t.text "meta_description"
    t.string "name"
    t.string "slug"
    t.text "summary"
    t.text "text"
    t.string "twitter"
    t.string "url"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "featured_image_alt"
    t.text "featured_image_credit"
    t.string "migration_identifier"
    t.index ["about_id"], name: "index_university_organization_localizations_on_about_id"
    t.index ["language_id"], name: "index_university_organization_localizations_on_language_id"
    t.index ["university_id"], name: "index_university_organization_localizations_on_university_id"
  end

  create_table "university_organizations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.string "phone"
    t.string "email"
    t.boolean "active", default: true
    t.string "siren"
    t.integer "kind", default: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nic"
    t.float "latitude"
    t.float "longitude"
    t.string "migration_identifier"
    t.index ["university_id"], name: "index_university_organizations_on_university_id"
  end

  create_table "university_people", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "user_id"
    t.boolean "is_researcher"
    t.boolean "is_teacher"
    t.boolean "is_administration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_mobile"
    t.string "email"
    t.boolean "habilitation", default: false
    t.boolean "tenure", default: false
    t.boolean "is_alumnus", default: false
    t.boolean "is_author"
    t.integer "gender"
    t.date "birthdate"
    t.string "phone_professional"
    t.string "phone_personal"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.integer "address_visibility", default: 0
    t.integer "linkedin_visibility", default: 0
    t.integer "twitter_visibility", default: 0
    t.integer "mastodon_visibility", default: 0
    t.integer "phone_mobile_visibility", default: 0
    t.integer "phone_professional_visibility", default: 0
    t.integer "phone_personal_visibility", default: 0
    t.integer "email_visibility", default: 0
    t.index ["university_id"], name: "index_university_people_on_university_id"
    t.index ["user_id"], name: "index_university_people_on_user_id"
  end

  create_table "university_people_person_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "category_id", null: false
    t.index ["category_id"], name: "index_university_people_person_categories_on_category_id"
    t.index ["person_id"], name: "index_university_people_person_categories_on_person_id"
  end

  create_table "university_person_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.integer "position", default: 0
    t.boolean "is_taxonomy", default: false
    t.string "bodyclass"
    t.index ["parent_id"], name: "index_university_person_categories_on_parent_id"
    t.index ["university_id"], name: "index_university_person_categories_on_university_id"
  end

  create_table "university_person_category_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.text "meta_description"
    t.text "summary"
    t.index ["about_id"], name: "index_university_person_category_localizations_on_about_id"
    t.index ["language_id"], name: "index_university_person_category_localizations_on_language_id"
    t.index ["slug"], name: "index_university_person_category_localizations_on_slug"
    t.index ["university_id"], name: "idx_on_university_id_1d7978113b"
  end

  create_table "university_person_experience_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_university_person_experience_localizations_on_about_id"
    t.index ["language_id"], name: "idx_on_language_id_61a5fb5403"
    t.index ["university_id"], name: "idx_on_university_id_1be9c668d5"
  end

  create_table "university_person_experiences", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "person_id", null: false
    t.uuid "organization_id", null: false
    t.integer "from_year"
    t.integer "to_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_university_person_experiences_on_organization_id"
    t.index ["person_id"], name: "index_university_person_experiences_on_person_id"
    t.index ["university_id"], name: "index_university_person_experiences_on_university_id"
  end

  create_table "university_person_involvement_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_university_person_involvement_localizations_on_about_id"
    t.index ["language_id"], name: "idx_on_language_id_75d7367448"
    t.index ["university_id"], name: "idx_on_university_id_0b815cf13a"
  end

  create_table "university_person_involvements", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "person_id", null: false
    t.integer "kind"
    t.string "target_type", null: false
    t.uuid "target_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_university_person_involvements_on_person_id"
    t.index ["target_type", "target_id"], name: "index_university_person_involvements_on_target"
    t.index ["university_id"], name: "index_university_person_involvements_on_university_id"
  end

  create_table "university_person_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "biography"
    t.string "first_name"
    t.string "last_name"
    t.string "linkedin"
    t.string "mastodon"
    t.text "meta_description"
    t.string "name"
    t.text "picture_credit"
    t.string "slug"
    t.text "summary"
    t.string "twitter"
    t.string "url"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.index ["about_id"], name: "index_university_person_localizations_on_about_id"
    t.index ["language_id"], name: "index_university_person_localizations_on_language_id"
    t.index ["slug"], name: "index_university_person_localizations_on_slug"
    t.index ["university_id"], name: "index_university_person_localizations_on_university_id"
  end

  create_table "university_role_localizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.uuid "about_id"
    t.uuid "language_id"
    t.uuid "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_university_role_localizations_on_about_id"
    t.index ["language_id"], name: "index_university_role_localizations_on_language_id"
    t.index ["university_id"], name: "index_university_role_localizations_on_university_id"
  end

  create_table "university_roles", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "target_type"
    t.uuid "target_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id"], name: "index_university_roles_on_target"
    t.index ["university_id"], name: "index_university_roles_on_university_id"
  end

  create_table "user_favorites", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_type", "about_id"], name: "index_user_favorites_on_about"
    t.index ["user_id"], name: "index_user_favorites_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "language_id"
    t.string "mobile_phone"
    t.integer "second_factor_attempts_count", default: 0
    t.string "encrypted_otp_secret_key"
    t.string "encrypted_otp_secret_key_iv"
    t.string "encrypted_otp_secret_key_salt"
    t.string "direct_otp"
    t.datetime "direct_otp_sent_at", precision: nil
    t.datetime "totp_timestamp", precision: nil
    t.string "session_token"
    t.string "picture_url"
    t.string "direct_otp_delivery_method"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "university_id"], name: "index_users_on_email_and_university_id", unique: true
    t.index ["encrypted_otp_secret_key"], name: "index_users_on_encrypted_otp_secret_key", unique: true
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["university_id"], name: "index_users_on_university_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "administration_location_localizations", "administration_locations", column: "about_id"
  add_foreign_key "administration_location_localizations", "languages"
  add_foreign_key "administration_location_localizations", "universities"
  add_foreign_key "administration_locations", "universities"
  add_foreign_key "administration_qualiopi_indicators", "administration_qualiopi_criterions", column: "criterion_id"
  add_foreign_key "communication_blocks", "communication_websites"
  add_foreign_key "communication_blocks", "universities"
  add_foreign_key "communication_extranet_connections", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_connections", "universities"
  add_foreign_key "communication_extranet_document_categories", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_document_categories", "universities"
  add_foreign_key "communication_extranet_document_category_localizations", "communication_extranet_document_categories", column: "about_id"
  add_foreign_key "communication_extranet_document_category_localizations", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_document_category_localizations", "languages"
  add_foreign_key "communication_extranet_document_category_localizations", "universities"
  add_foreign_key "communication_extranet_document_kind_localizations", "communication_extranet_document_kinds", column: "about_id"
  add_foreign_key "communication_extranet_document_kind_localizations", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_document_kind_localizations", "languages"
  add_foreign_key "communication_extranet_document_kind_localizations", "universities"
  add_foreign_key "communication_extranet_document_kinds", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_document_kinds", "universities"
  add_foreign_key "communication_extranet_document_localizations", "communication_extranet_documents", column: "about_id"
  add_foreign_key "communication_extranet_document_localizations", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_document_localizations", "languages"
  add_foreign_key "communication_extranet_document_localizations", "universities"
  add_foreign_key "communication_extranet_documents", "communication_extranet_document_categories", column: "category_id"
  add_foreign_key "communication_extranet_documents", "communication_extranet_document_kinds", column: "kind_id"
  add_foreign_key "communication_extranet_documents", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_documents", "universities"
  add_foreign_key "communication_extranet_localizations", "communication_extranets", column: "about_id"
  add_foreign_key "communication_extranet_localizations", "languages"
  add_foreign_key "communication_extranet_localizations", "universities"
  add_foreign_key "communication_extranet_post_categories", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_post_categories", "universities"
  add_foreign_key "communication_extranet_post_category_localizations", "communication_extranet_post_categories", column: "about_id"
  add_foreign_key "communication_extranet_post_category_localizations", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_post_category_localizations", "languages"
  add_foreign_key "communication_extranet_post_category_localizations", "universities"
  add_foreign_key "communication_extranet_post_localizations", "communication_extranet_posts", column: "about_id"
  add_foreign_key "communication_extranet_post_localizations", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_post_localizations", "languages"
  add_foreign_key "communication_extranet_post_localizations", "universities"
  add_foreign_key "communication_extranet_posts", "communication_extranet_post_categories", column: "category_id"
  add_foreign_key "communication_extranet_posts", "communication_extranets", column: "extranet_id"
  add_foreign_key "communication_extranet_posts", "universities"
  add_foreign_key "communication_extranet_posts", "university_people", column: "author_id"
  add_foreign_key "communication_extranets", "languages", column: "default_language_id"
  add_foreign_key "communication_extranets", "universities"
  add_foreign_key "communication_media_categories", "communication_media_categories", column: "parent_id"
  add_foreign_key "communication_media_categories", "universities"
  add_foreign_key "communication_media_category_localizations", "communication_media_categories", column: "about_id"
  add_foreign_key "communication_media_category_localizations", "languages"
  add_foreign_key "communication_media_category_localizations", "universities"
  add_foreign_key "communication_media_collection_localizations", "communication_media_collections", column: "about_id"
  add_foreign_key "communication_media_collection_localizations", "languages"
  add_foreign_key "communication_media_collection_localizations", "universities"
  add_foreign_key "communication_media_collections", "universities"
  add_foreign_key "communication_media_contexts", "active_storage_blobs"
  add_foreign_key "communication_media_contexts", "communication_medias"
  add_foreign_key "communication_media_contexts", "universities"
  add_foreign_key "communication_media_localizations", "communication_medias", column: "about_id"
  add_foreign_key "communication_media_localizations", "languages"
  add_foreign_key "communication_media_localizations", "universities"
  add_foreign_key "communication_medias", "active_storage_blobs", column: "original_blob_id"
  add_foreign_key "communication_medias", "communication_media_collections"
  add_foreign_key "communication_medias", "universities"
  add_foreign_key "communication_website_agenda_categories", "communication_website_agenda_categories", column: "parent_id"
  add_foreign_key "communication_website_agenda_categories", "communication_websites"
  add_foreign_key "communication_website_agenda_categories", "education_programs", column: "program_id"
  add_foreign_key "communication_website_agenda_categories", "universities"
  add_foreign_key "communication_website_agenda_categories_exhibitions", "communication_website_agenda_categories", column: "category_id"
  add_foreign_key "communication_website_agenda_categories_exhibitions", "communication_website_agenda_exhibitions", column: "exhibition_id"
  add_foreign_key "communication_website_agenda_category_localizations", "communication_website_agenda_categories", column: "about_id"
  add_foreign_key "communication_website_agenda_category_localizations", "communication_websites"
  add_foreign_key "communication_website_agenda_category_localizations", "languages"
  add_foreign_key "communication_website_agenda_category_localizations", "universities"
  add_foreign_key "communication_website_agenda_event_days", "communication_website_agenda_events"
  add_foreign_key "communication_website_agenda_event_days", "communication_websites"
  add_foreign_key "communication_website_agenda_event_days", "languages"
  add_foreign_key "communication_website_agenda_event_days", "universities"
  add_foreign_key "communication_website_agenda_event_localizations", "communication_website_agenda_events", column: "about_id"
  add_foreign_key "communication_website_agenda_event_localizations", "communication_websites"
  add_foreign_key "communication_website_agenda_event_localizations", "languages"
  add_foreign_key "communication_website_agenda_event_localizations", "universities"
  add_foreign_key "communication_website_agenda_event_time_slot_localizations", "communication_website_agenda_event_time_slots", column: "about_id"
  add_foreign_key "communication_website_agenda_event_time_slot_localizations", "communication_websites"
  add_foreign_key "communication_website_agenda_event_time_slot_localizations", "universities"
  add_foreign_key "communication_website_agenda_event_time_slots", "communication_website_agenda_events"
  add_foreign_key "communication_website_agenda_event_time_slots", "communication_websites"
  add_foreign_key "communication_website_agenda_event_time_slots", "universities"
  add_foreign_key "communication_website_agenda_events", "communication_website_agenda_events", column: "parent_id"
  add_foreign_key "communication_website_agenda_events", "communication_websites"
  add_foreign_key "communication_website_agenda_events", "universities"
  add_foreign_key "communication_website_agenda_events", "users", column: "created_by_id"
  add_foreign_key "communication_website_agenda_exhibition_localizations", "communication_website_agenda_exhibitions", column: "about_id"
  add_foreign_key "communication_website_agenda_exhibition_localizations", "communication_websites"
  add_foreign_key "communication_website_agenda_exhibition_localizations", "universities"
  add_foreign_key "communication_website_agenda_exhibitions", "communication_websites"
  add_foreign_key "communication_website_agenda_exhibitions", "universities"
  add_foreign_key "communication_website_agenda_exhibitions", "users", column: "created_by_id"
  add_foreign_key "communication_website_connections", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_connections", "universities"
  add_foreign_key "communication_website_git_file_layouts", "communication_websites"
  add_foreign_key "communication_website_git_file_layouts", "universities"
  add_foreign_key "communication_website_git_file_orphans", "communication_websites"
  add_foreign_key "communication_website_git_file_orphans", "universities"
  add_foreign_key "communication_website_git_files", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_localizations", "communication_websites", column: "about_id"
  add_foreign_key "communication_website_localizations", "languages"
  add_foreign_key "communication_website_localizations", "universities"
  add_foreign_key "communication_website_menu_items", "communication_website_menu_items", column: "parent_id"
  add_foreign_key "communication_website_menu_items", "communication_website_menus", column: "menu_id"
  add_foreign_key "communication_website_menu_items", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_menu_items", "universities"
  add_foreign_key "communication_website_menus", "communication_website_menus", column: "original_id"
  add_foreign_key "communication_website_menus", "communication_websites"
  add_foreign_key "communication_website_menus", "languages"
  add_foreign_key "communication_website_menus", "universities"
  add_foreign_key "communication_website_page_categories", "communication_website_page_categories", column: "parent_id"
  add_foreign_key "communication_website_page_categories", "communication_websites"
  add_foreign_key "communication_website_page_categories", "education_programs", column: "program_id"
  add_foreign_key "communication_website_page_categories", "universities"
  add_foreign_key "communication_website_page_category_localizations", "communication_website_page_categories", column: "about_id"
  add_foreign_key "communication_website_page_category_localizations", "communication_websites"
  add_foreign_key "communication_website_page_category_localizations", "languages"
  add_foreign_key "communication_website_page_category_localizations", "universities"
  add_foreign_key "communication_website_page_localizations", "communication_website_pages", column: "about_id"
  add_foreign_key "communication_website_page_localizations", "communication_websites"
  add_foreign_key "communication_website_page_localizations", "languages"
  add_foreign_key "communication_website_page_localizations", "universities"
  add_foreign_key "communication_website_pages", "communication_website_pages", column: "parent_id"
  add_foreign_key "communication_website_pages", "communication_websites"
  add_foreign_key "communication_website_pages", "universities"
  add_foreign_key "communication_website_permalinks", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_permalinks", "universities"
  add_foreign_key "communication_website_portfolio_categories", "communication_website_portfolio_categories", column: "parent_id"
  add_foreign_key "communication_website_portfolio_categories", "communication_websites"
  add_foreign_key "communication_website_portfolio_categories", "education_programs", column: "program_id"
  add_foreign_key "communication_website_portfolio_categories", "universities"
  add_foreign_key "communication_website_portfolio_category_localizations", "communication_website_portfolio_categories", column: "about_id"
  add_foreign_key "communication_website_portfolio_category_localizations", "communication_websites"
  add_foreign_key "communication_website_portfolio_category_localizations", "languages"
  add_foreign_key "communication_website_portfolio_category_localizations", "universities"
  add_foreign_key "communication_website_portfolio_project_localizations", "communication_website_portfolio_projects", column: "about_id"
  add_foreign_key "communication_website_portfolio_project_localizations", "communication_websites"
  add_foreign_key "communication_website_portfolio_project_localizations", "languages"
  add_foreign_key "communication_website_portfolio_project_localizations", "universities"
  add_foreign_key "communication_website_portfolio_projects", "communication_websites"
  add_foreign_key "communication_website_portfolio_projects", "universities"
  add_foreign_key "communication_website_portfolio_projects", "users", column: "created_by_id"
  add_foreign_key "communication_website_post_categories", "communication_website_post_categories", column: "parent_id"
  add_foreign_key "communication_website_post_categories", "communication_websites"
  add_foreign_key "communication_website_post_categories", "education_programs", column: "program_id"
  add_foreign_key "communication_website_post_categories", "universities"
  add_foreign_key "communication_website_post_category_localizations", "communication_website_post_categories", column: "about_id"
  add_foreign_key "communication_website_post_category_localizations", "communication_websites"
  add_foreign_key "communication_website_post_category_localizations", "languages"
  add_foreign_key "communication_website_post_category_localizations", "universities"
  add_foreign_key "communication_website_post_localizations", "communication_website_posts", column: "about_id"
  add_foreign_key "communication_website_post_localizations", "communication_websites"
  add_foreign_key "communication_website_post_localizations", "languages"
  add_foreign_key "communication_website_post_localizations", "universities"
  add_foreign_key "communication_website_posts", "communication_websites"
  add_foreign_key "communication_website_posts", "universities"
  add_foreign_key "communication_websites", "languages", column: "default_language_id"
  add_foreign_key "communication_websites", "universities"
  add_foreign_key "education_academic_years", "universities"
  add_foreign_key "education_cohorts", "education_academic_years", column: "academic_year_id"
  add_foreign_key "education_cohorts", "education_programs", column: "program_id"
  add_foreign_key "education_cohorts", "education_schools", column: "school_id"
  add_foreign_key "education_cohorts", "universities"
  add_foreign_key "education_diploma_localizations", "education_diplomas", column: "about_id"
  add_foreign_key "education_diploma_localizations", "languages"
  add_foreign_key "education_diploma_localizations", "universities"
  add_foreign_key "education_diplomas", "universities"
  add_foreign_key "education_program_categories", "education_program_categories", column: "parent_id"
  add_foreign_key "education_program_categories", "universities"
  add_foreign_key "education_program_category_localizations", "education_program_categories", column: "about_id"
  add_foreign_key "education_program_category_localizations", "languages"
  add_foreign_key "education_program_category_localizations", "universities"
  add_foreign_key "education_program_localizations", "education_programs", column: "about_id"
  add_foreign_key "education_program_localizations", "languages"
  add_foreign_key "education_program_localizations", "universities"
  add_foreign_key "education_programs", "education_programs", column: "parent_id"
  add_foreign_key "education_programs", "universities"
  add_foreign_key "education_school_localizations", "education_schools", column: "about_id"
  add_foreign_key "education_school_localizations", "languages"
  add_foreign_key "education_school_localizations", "universities"
  add_foreign_key "education_schools", "universities"
  add_foreign_key "emergency_messages", "universities"
  add_foreign_key "imports", "languages"
  add_foreign_key "imports", "universities"
  add_foreign_key "imports", "users"
  add_foreign_key "research_journal_localizations", "languages"
  add_foreign_key "research_journal_localizations", "research_journals", column: "about_id"
  add_foreign_key "research_journal_localizations", "universities"
  add_foreign_key "research_journal_paper_kind_localizations", "languages"
  add_foreign_key "research_journal_paper_kind_localizations", "research_journal_paper_kinds", column: "about_id"
  add_foreign_key "research_journal_paper_kind_localizations", "universities"
  add_foreign_key "research_journal_paper_kinds", "research_journals", column: "journal_id"
  add_foreign_key "research_journal_paper_kinds", "universities"
  add_foreign_key "research_journal_paper_localizations", "languages"
  add_foreign_key "research_journal_paper_localizations", "research_journal_papers", column: "about_id"
  add_foreign_key "research_journal_paper_localizations", "universities"
  add_foreign_key "research_journal_papers", "research_journal_paper_kinds", column: "kind_id"
  add_foreign_key "research_journal_papers", "research_journal_volumes"
  add_foreign_key "research_journal_papers", "research_journals"
  add_foreign_key "research_journal_papers", "universities"
  add_foreign_key "research_journal_papers", "users", column: "updated_by_id"
  add_foreign_key "research_journal_papers_researchers", "research_journal_papers", column: "paper_id"
  add_foreign_key "research_journal_papers_researchers", "university_people", column: "researcher_id"
  add_foreign_key "research_journal_volume_localizations", "languages"
  add_foreign_key "research_journal_volume_localizations", "research_journal_volumes", column: "about_id"
  add_foreign_key "research_journal_volume_localizations", "universities"
  add_foreign_key "research_journal_volumes", "research_journals"
  add_foreign_key "research_journal_volumes", "universities"
  add_foreign_key "research_journals", "universities"
  add_foreign_key "research_laboratories", "universities"
  add_foreign_key "research_laboratory_axes", "research_laboratories"
  add_foreign_key "research_laboratory_axes", "universities"
  add_foreign_key "research_laboratory_axis_localizations", "languages"
  add_foreign_key "research_laboratory_axis_localizations", "research_laboratory_axes", column: "about_id"
  add_foreign_key "research_laboratory_axis_localizations", "universities"
  add_foreign_key "research_laboratory_localizations", "languages"
  add_foreign_key "research_laboratory_localizations", "research_laboratories", column: "about_id"
  add_foreign_key "research_laboratory_localizations", "universities"
  add_foreign_key "research_theses", "research_laboratories"
  add_foreign_key "research_theses", "universities"
  add_foreign_key "research_theses", "university_people", column: "author_id"
  add_foreign_key "research_theses", "university_people", column: "director_id"
  add_foreign_key "research_thesis_localizations", "languages"
  add_foreign_key "research_thesis_localizations", "research_theses", column: "about_id"
  add_foreign_key "research_thesis_localizations", "universities"
  add_foreign_key "search_index", "communication_extranets", column: "extranet_id"
  add_foreign_key "search_index", "communication_websites", column: "website_id"
  add_foreign_key "search_index", "universities"
  add_foreign_key "universities", "languages", column: "default_language_id"
  add_foreign_key "university_apps", "universities"
  add_foreign_key "university_organization_categories", "universities"
  add_foreign_key "university_organization_categories", "university_organization_categories", column: "parent_id"
  add_foreign_key "university_organization_categories_organizations", "university_organization_categories", column: "category_id"
  add_foreign_key "university_organization_categories_organizations", "university_organizations", column: "organization_id"
  add_foreign_key "university_organization_category_localizations", "languages"
  add_foreign_key "university_organization_category_localizations", "universities"
  add_foreign_key "university_organization_category_localizations", "university_organization_categories", column: "about_id"
  add_foreign_key "university_organization_localizations", "languages"
  add_foreign_key "university_organization_localizations", "universities"
  add_foreign_key "university_organization_localizations", "university_organizations", column: "about_id"
  add_foreign_key "university_organizations", "universities"
  add_foreign_key "university_people", "universities"
  add_foreign_key "university_people", "users"
  add_foreign_key "university_people_person_categories", "university_people", column: "person_id"
  add_foreign_key "university_people_person_categories", "university_person_categories", column: "category_id"
  add_foreign_key "university_person_categories", "universities"
  add_foreign_key "university_person_categories", "university_person_categories", column: "parent_id"
  add_foreign_key "university_person_category_localizations", "languages"
  add_foreign_key "university_person_category_localizations", "universities"
  add_foreign_key "university_person_category_localizations", "university_person_categories", column: "about_id"
  add_foreign_key "university_person_experience_localizations", "languages"
  add_foreign_key "university_person_experience_localizations", "universities"
  add_foreign_key "university_person_experience_localizations", "university_person_experiences", column: "about_id"
  add_foreign_key "university_person_experiences", "universities"
  add_foreign_key "university_person_experiences", "university_organizations", column: "organization_id"
  add_foreign_key "university_person_experiences", "university_people", column: "person_id"
  add_foreign_key "university_person_involvement_localizations", "languages"
  add_foreign_key "university_person_involvement_localizations", "universities"
  add_foreign_key "university_person_involvement_localizations", "university_person_involvements", column: "about_id"
  add_foreign_key "university_person_involvements", "universities"
  add_foreign_key "university_person_involvements", "university_people", column: "person_id"
  add_foreign_key "university_person_localizations", "languages"
  add_foreign_key "university_person_localizations", "universities"
  add_foreign_key "university_person_localizations", "university_people", column: "about_id"
  add_foreign_key "university_role_localizations", "languages"
  add_foreign_key "university_role_localizations", "universities"
  add_foreign_key "university_role_localizations", "university_roles", column: "about_id"
  add_foreign_key "university_roles", "universities"
  add_foreign_key "user_favorites", "users"
  add_foreign_key "users", "languages"
  add_foreign_key "users", "universities"
end
