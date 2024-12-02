require 'swagger_helper'

RSpec.describe 'Communication::Website::Post' do
  fixtures :all

  path '/communication/websites/{website_id}/posts' do
    get "Lists a website's posts" do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end
    end

    post 'Creates a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :communication_website_post, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              migration_identifier: { type: :string, description: 'Unique migration identifier of the post' },
              full_width: { type: :boolean },
              localizations_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    migration_identifier: { type: :string, description: 'Unique migration identifier of the localization' },
                    language: { type: :string, description: 'ISO 639-1 code of the language', example: 'fr' },
                    title: { type: :string },
                    # TODO Featured image & blocks
                    meta_description: { type: :string },
                    pinned: { type: :boolean },
                    published: { type: :boolean },
                    published_at: { type: :string, format: 'date-time' },
                    slug: { type: :string },
                    subtitle: { type: :string },
                    summary: { type: :string },
                    text: { type: :string }
                  },
                  required: [:migration_identifier, :language, :title]
                }
              }
            },
            required: [:migration_identifier, :localizations_attributes]
          }
        },
        required: [:post]
      }
      let(:communication_website_post) {
        {
          post: {
            migration_identifier: 'post-from-api-1',
            full_width: false,
            localizations_attributes: [
              {
                migration_identifier: 'post-from-api-1-fr',
                language: 'fr',
                title: 'Ma nouvelle actualité',
                meta_description: 'Une nouvelle actualité depuis l\'API',
                pinned: false,
                published: true,
                published_at: '2024-11-29T16:49:00Z',
                slug: 'ma-nouvelle-actualite',
                subtitle: 'Une nouvelle actualité',
                summary: 'Ceci est une nouvelle actualité créée depuis l\'API.'
              }
            ]
          }
        }
      }

      response '201', 'Successful creation' do
        it 'creates a post and its localization', rswag: true do |example|
          assert_difference ->{ Communication::Website::Post.count } => 1, ->{ Communication::Website::Post::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_post) {
          {
            post: {
              full_width: false,
              localizations_attributes: [
                {
                  migration_identifier: 'post-from-api-1-fr',
                  language: 'fr',
                  title: 'Ma nouvelle actualité',
                  meta_description: 'Une nouvelle actualité depuis l\'API',
                  pinned: false,
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  slug: 'ma-nouvelle-actualite',
                  subtitle: 'Une nouvelle actualité',
                  summary: 'Ceci est une nouvelle actualité créée depuis l\'API.'
                }
              ]
            }
          }
        }
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_post) {
          {
            post: {
              migration_identifier: 'post-from-api-1',
              full_width: false,
              localizations_attributes: [
                {
                  migration_identifier: 'post-from-api-1-fr',
                  language: 'fr',
                  title: nil
                }
              ]
            }
          }
        }
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/posts/{id}' do
    get 'Shows a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Post identifier'
      let(:id) { communication_website_posts(:test_post).id }

      response '200', 'Successful operation' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '404', 'Post not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Post identifier'
      let(:id) { communication_website_posts(:test_post).id }

      parameter name: :communication_website_post, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              migration_identifier: { type: :string, description: 'Unique migration identifier of the post' },
              full_width: { type: :boolean },
              localizations_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    migration_identifier: { type: :string, description: 'Unique migration identifier of the localization' },
                    language: { type: :string, description: 'ISO 639-1 code of the language', example: 'fr' },
                    title: { type: :string },
                    # TODO Featured image & blocks
                    meta_description: { type: :string },
                    pinned: { type: :boolean },
                    published: { type: :boolean },
                    published_at: { type: :string, format: 'date-time' },
                    slug: { type: :string },
                    subtitle: { type: :string },
                    summary: { type: :string },
                    text: { type: :string }
                  },
                  required: [:migration_identifier, :language, :title]
                }
              }
            },
            required: [:migration_identifier, :localizations_attributes]
          }
        },
        required: [:post]
      }
      let(:communication_website_post) {
        test_post = communication_website_posts(:test_post)
        test_post_l10n = communication_website_post_localizations(:test_post_fr)
        {
          post: {
            migration_identifier: test_post.migration_identifier,
            full_width: test_post.full_width,
            localizations_attributes: [
              {
                migration_identifier: test_post_l10n.migration_identifier,
                language: test_post_l10n.language.iso_code,
                title: "Mon nouveau titre",
                meta_description: test_post_l10n.meta_description,
                pinned: test_post_l10n.pinned,
                published: test_post_l10n.published,
                published_at: test_post_l10n.published_at,
                slug: test_post_l10n.slug,
                subtitle: test_post_l10n.subtitle,
                summary: test_post_l10n.summary
              }
            ]
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau titre", communication_website_post_localizations(:test_post_fr).reload.title)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_post) {
          test_post = communication_website_posts(:test_post)
          test_post_l10n = communication_website_post_localizations(:test_post_fr)
          {
            post: {
              full_width: test_post.full_width,
              localizations_attributes: [
                {
                  migration_identifier: test_post_l10n.migration_identifier,
                  language: test_post_l10n.language.iso_code,
                  title: test_post_l10n.title,
                  meta_description: test_post_l10n.meta_description,
                  pinned: test_post_l10n.pinned,
                  published: test_post_l10n.published,
                  published_at: test_post_l10n.published_at,
                  slug: test_post_l10n.slug,
                  subtitle: test_post_l10n.subtitle,
                  summary: test_post_l10n.summary
                }
              ]
            }
          }
        }
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '404', 'Post not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_post) {
          test_post = communication_website_posts(:test_post)
          test_post_l10n = communication_website_post_localizations(:test_post_fr)
          {
            post: {
              migration_identifier: test_post.migration_identifier,
              full_width: test_post.full_width,
              localizations_attributes: [
                {
                  migration_identifier: test_post_l10n.migration_identifier,
                  language: test_post_l10n.language.iso_code,
                  title: nil,
                  meta_description: test_post_l10n.meta_description,
                  pinned: test_post_l10n.pinned,
                  published: test_post_l10n.published,
                  published_at: test_post_l10n.published_at,
                  slug: test_post_l10n.slug,
                  subtitle: test_post_l10n.subtitle,
                  summary: test_post_l10n.summary
                }
              ]
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Post identifier'
      let(:id) { communication_website_posts(:test_post).id }

      response '200', 'Successful deletion' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '404', 'Post not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end
