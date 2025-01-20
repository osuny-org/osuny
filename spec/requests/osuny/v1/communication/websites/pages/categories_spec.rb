require 'swagger_helper'

RSpec.describe 'Communication::Website::Page::Category' do
  fixtures :all

  path '/communication/websites/{website_id}/pages/categories' do
    get "Lists a website's page categories" do
      tags 'Communication::Website::Page::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/communication_website_page_category' }
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

    post 'Creates a page category' do
      tags 'Communication::Website::Page::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :communication_website_page_category, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          category: {
            '$ref': '#/components/schemas/communication_website_page_category'
          }
        },
        required: [:category]
      }
      let(:communication_website_page_category) {
        {
          category: {
            migration_identifier: 'page-category-from-api-1',
            localizations: {
              fr: {
                migration_identifier: 'page-category-from-api-1-fr',
                name: 'Ma nouvelle catégorie',
                meta_description: 'Une nouvelle catégorie depuis l\'API',
                featured_image: {
                  url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                  alt: 'La lumière brille sur les parois du canyon',
                  credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                },
                slug: 'ma-nouvelle-categorie',
                summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.',
                blocks: [
                  {
                    migration_identifier: 'page-category-from-api-1-fr-block-1',
                    template_kind: 'chapter',
                    title: 'Mon premier chapitre',
                    position: 1,
                    published: true,
                    data: {
                      layout: "no_background",
                      text: "<p>Ceci est mon premier chapitre</p>"
                    }
                  }
                ]
              }
            }
          }
        }
      }

      response '201', 'Successful creation' do
        it 'creates a page category and its localization', rswag: true, vcr: true do |example|
          assert_difference ->{ Communication::Website::Page::Category.count } => 1, ->{ Communication::Website::Page::Category::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_page_category) {
          {
            category: {
              localizations: {
                fr: {
                  migration_identifier: 'page-category-from-api-1-fr',
                  name: 'Ma nouvelle catégorie',
                  meta_description: 'Une nouvelle catégorie depuis l\'API',
                  slug: 'ma-nouvelle-categorie',
                  summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
                }
              }
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
        let(:communication_website_page_category) {
          {
            category: {
              migration_identifier: 'page-category-from-api-1',
              localizations: {
                fr: {
                  migration_identifier: 'page-category-from-api-1-fr',
                  meta_description: 'Une nouvelle catégorie depuis l\'API',
                  summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
                }
              }
            }
          }
        }
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/pages/categories/upsert' do
    post 'Upsert page categories' do
      tags 'Communication::Website::Page::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :categories, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          categories: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/communication_website_page_categories'
            }
          }
        },
        required: [:categories]
      }
      let(:categories) {
        test_category = communication_website_page_categories(:test_category)
        test_category_l10n = communication_website_page_category_localizations(:test_category_fr)
        {
          categories: [
            {
              migration_identifier: 'page-category-from-api-1',
              localizations: {
                fr: {
                  migration_identifier: 'page-category-from-api-1-fr',
                  name: 'Ma nouvelle catégorie',
                  meta_description: 'Une nouvelle catégorie depuis l\'API',
                  featured_image: {
                    url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                    alt: 'La lumière brille sur les parois du canyon',
                    credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                  },
                  slug: 'ma-nouvelle-categorie',
                  summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.',
                  blocks: [
                    {
                      migration_identifier: 'page-category-from-api-1-fr-block-1',
                      template_kind: 'chapter',
                      title: 'Mon premier chapitre',
                      position: 1,
                      published: true,
                      data: {
                        layout: "no_background",
                        text: "<p>Ceci est mon premier chapitre</p>"
                      }
                    }
                  ]
                }
              }
            },
            {
              migration_identifier: test_category.migration_identifier,
              parent_id: test_category.parent_id,
              position: test_category.position,
              is_taxonomy: test_category.is_taxonomy,
              localizations: {
                test_category_l10n.language.iso_code => {
                  migration_identifier: test_category_l10n.migration_identifier,
                  name: "Mon nouveau nom",
                  meta_description: test_category_l10n.meta_description,
                  path: test_category_l10n.path,
                  slug: test_category_l10n.slug,
                  summary: test_category_l10n.summary
                }
              }
            }
          ]
        }
      }

      response '200', 'Successful upsertion' do
        it 'creates a page category and updates another with their localizations', rswag: true, vcr: true do |example|
          assert_difference ->{ Communication::Website::Page::Category.count } => 1, ->{ Communication::Website::Page::Category::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:categories) {
          test_category = communication_website_page_categories(:test_category)
          test_category_l10n = communication_website_page_category_localizations(:test_category_fr)
          {
            categories: [
              {
                localizations: {
                  fr: {
                    migration_identifier: 'page-category-from-api-1-fr',
                    name: 'Ma nouvelle catégorie',
                    meta_description: 'Une nouvelle catégorie depuis l\'API',
                    featured_image: {
                      url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                      alt: 'La lumière brille sur les parois du canyon',
                      credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                    },
                    slug: 'ma-nouvelle-categorie',
                    summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.',
                    blocks: [
                      {
                        migration_identifier: 'page-category-from-api-1-fr-block-1',
                        template_kind: 'chapter',
                        title: 'Mon premier chapitre',
                        position: 1,
                        published: true,
                        data: {
                          layout: "no_background",
                          text: "<p>Ceci est mon premier chapitre</p>"
                        }
                      }
                    ]
                  }
                }
              },
              {
                parent_id: test_category.parent_id,
                position: test_category.position,
                is_taxonomy: test_category.is_taxonomy,
                localizations: {
                  test_category_l10n.language.iso_code => {
                    migration_identifier: test_category_l10n.migration_identifier,
                    name: "Mon nouveau nom",
                    meta_description: test_category_l10n.meta_description,
                    path: test_category_l10n.path,
                    slug: test_category_l10n.slug,
                    summary: test_category_l10n.summary
                  }
                }
              }
            ]
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
        let(:categories) {
          test_category = communication_website_page_categories(:test_category)
          test_category_l10n = communication_website_page_category_localizations(:test_category_fr)
          {
            categories: [
              {
                migration_identifier: 'page-category-from-api-1',
                localizations: {
                  fr: {
                    migration_identifier: 'page-category-from-api-1-fr',
                    name: nil,
                    meta_description: 'Une nouvelle catégorie depuis l\'API',
                    summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
                  }
                }
              },
              {
                migration_identifier: test_category.migration_identifier,
                parent_id: test_category.parent_id,
                position: test_category.position,
                is_taxonomy: test_category.is_taxonomy,
                localizations: {
                  test_category_l10n.language.iso_code => {
                    migration_identifier: test_category_l10n.migration_identifier,
                    name: nil,
                    meta_description: test_category_l10n.meta_description,
                    summary: test_category_l10n.summary
                  }
                }
              }
            ]
          }
        }
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/pages/categories/{id}' do
    get 'Shows a page category' do
      tags 'Communication::Website::Page::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Category identifier'
      let(:id) { communication_website_page_categories(:test_category).id }

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

      response '404', 'Category not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates a page category' do
      tags 'Communication::Website::Page::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Category identifier'
      let(:id) { communication_website_page_categories(:test_category).id }

      parameter name: :communication_website_page_category, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          category: {
            '$ref': '#/components/schemas/communication_website_page_category'
          }
        },
        required: [:category]
      }
      let(:communication_website_page_category) {
        test_category = communication_website_page_categories(:test_category)
        test_category_l10n = communication_website_page_category_localizations(:test_category_fr)
        {
          category: {
            migration_identifier: test_category.migration_identifier,
            parent_id: test_category.parent_id,
            position: test_category.position,
            is_taxonomy: test_category.is_taxonomy,
            localizations: {
              test_category_l10n.language.iso_code => {
                migration_identifier: test_category_l10n.migration_identifier,
                name: "Mon nouveau nom",
                meta_description: test_category_l10n.meta_description,
                path: test_category_l10n.path,
                slug: test_category_l10n.slug,
                summary: test_category_l10n.summary
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau nom", communication_website_page_category_localizations(:test_category_fr).reload.name)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_page_category) {
          test_category = communication_website_page_categories(:test_category)
          test_category_l10n = communication_website_page_category_localizations(:test_category_fr)
          {
            category: {
              parent_id: test_category.parent_id,
              position: test_category.position,
              is_taxonomy: test_category.is_taxonomy,
              localizations: {
                test_category_l10n.language.iso_code => {
                  migration_identifier: test_category_l10n.migration_identifier,
                  name: "Mon nouveau nom",
                  meta_description: test_category_l10n.meta_description,
                  path: test_category_l10n.path,
                  slug: test_category_l10n.slug,
                  summary: test_category_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end

      # TODO: Add test for missing migration identifier in localization

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '404', 'Category not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_page_category) {
          test_category = communication_website_page_categories(:test_category)
          test_category_l10n = communication_website_page_category_localizations(:test_category_fr)
          {
            category: {
              migration_identifier: test_category.migration_identifier,
              parent_id: test_category.parent_id,
              position: test_category.position,
              is_taxonomy: test_category.is_taxonomy,
              localizations: {
                test_category_l10n.language.iso_code => {
                  migration_identifier: test_category_l10n.migration_identifier,
                  name: nil,
                  meta_description: test_category_l10n.meta_description,
                  path: test_category_l10n.path,
                  slug: test_category_l10n.slug,
                  summary: test_category_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a page category' do
      tags 'Communication::Website::Page::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Category identifier'
      let(:id) { communication_website_page_categories(:test_category).id }

      response '204', 'Successful deletion' do
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

      response '404', 'Page not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end
