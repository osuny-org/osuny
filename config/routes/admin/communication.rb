namespace :communication do
  resources :authors, only: [:index, :show]
  scope 'photo-imports' do
    get 'unsplash' => 'photo_imports#unsplash'
    get 'pexels' => 'photo_imports#pexels'
  end
  resources :websites do
    member do
      get 'edit/language' => 'websites#edit_language', as: :edit_language
      get 'edit/technical' => 'websites#edit_technical', as: :edit_technical
      get :analytics
      get :security
      get :static
      get :production
      get :confirm_localization
      post :do_confirm_localization
      scope 'git-analysis' do
        get '' => 'websites/git_analysis#index', as: :git_analysis
        post '' => 'websites/git_analysis#launch'
      end
    end
    get 'style' => 'websites/preview#style', as: :style
    get 'assets/*path' => 'websites/preview#assets'
    resources :configs, controller: 'websites/configs', only: [:index, :show]
    resources :dependencies, controller: 'websites/dependencies', only: :index
    resources :connections, controller: 'websites/connections', only: [:index, :show] do
      collection do
        get 'indirect_object/:type' => 'websites/connections#indirect_object', as: :indirect_object
        get 'direct_source/:type' => 'websites/connections#direct_source', as: :direct_source
      end
    end
    resources :permalinks, controller: 'websites/permalinks', only: [:create, :destroy]
    namespace :page, path: 'pages' do
      resources :categories, controller: '/admin/communication/websites/pages/categories' do
        collection do
          post :reorder
        end
        member do
          get :children
          get :static
        end
      end
    end
    resources :pages, controller: 'websites/pages' do
      collection do
        post :reorder
        get 'list' => 'websites/pages#index_list'
      end
      member do
        get :children
        get :static
        get :preview
        get 'translate' => "websites/pages#translate", as: :translate
        post :duplicate
        post :publish
        post :connect
        post :disconnect
        post 'generate-from-template' => 'websites/pages#generate_from_template', as: :generate
      end
    end
    namespace :post, path: '' do
      resources :categories, controller: '/admin/communication/websites/posts/categories' do
        collection do
          post :reorder
        end
        member do
          get :children
          get :static
        end
      end
      resources :authors, controller: '/admin/communication/websites/posts/authors', only: [:index, :show]
    end
    resources :posts, controller: 'websites/posts' do
      collection do
        resources :curations, as: :post_curations, controller: 'websites/posts/curations', only: [:new, :create]
        post :publish_batch
      end
      member do
        get :static
        get :preview
        post :duplicate
        post :publish
      end
    end
    namespace :agenda do
      resources :events, controller: '/admin/communication/websites/agenda/events' do
        member do
          get :static
          post :duplicate
          post :publish
          post :save_time_slots
        end
      end
      resources :exhibitions, controller: '/admin/communication/websites/agenda/exhibitions' do
        member do
          get :static
          post :duplicate
          post :publish
        end
      end
      resources :categories, controller: '/admin/communication/websites/agenda/categories' do
        collection do
          post :reorder
        end
        member do
          get :children
          get :static
        end
      end
      root to: '/admin/communication/websites/agenda/events#index'
    end
    namespace :portfolio do
      resources :projects, controller: '/admin/communication/websites/portfolio/projects' do
        member do
          get :static
          post :duplicate
          post :publish
        end
      end
      resources :categories, controller: '/admin/communication/websites/portfolio/categories' do
        collection do
          post :reorder
        end
        member do
          get :children
          get :static
        end
      end
      root to: '/admin/communication/websites/portfolio/projects#index'
    end
    resources :menus, controller: 'websites/menus' do
      member do
        get :static
      end
      resources :items, controller: 'websites/menus/items', except: :index do
        collection do
          get :kind_switch
          post :reorder
        end
        member do
          get :children
        end
      end
    end
  end
  scope "/contents/:about_type/:about_id", as: :contents, controller: 'contents' do
    get :write
    get :structure
  end
  resources :blocks, controller: 'blocks', except: [:index] do
    collection do
      post :reorder
    end
    member do
      get :copy
      post :duplicate
      post :paste
    end
  end
  resources :extranets, controller: 'extranets' do
    member do
      get :confirm_localization
      post :do_confirm_localization
    end
    resources :alumni, only: :index, controller: 'extranets/alumni'
    resources :contacts, only: :index, controller: 'extranets/contacts' do
      collection do
        get :export_people
        get :export_organizations
        post :toggle
        post :connect
        post :disconnect
      end
    end
    resources :posts, controller: 'extranets/posts' do
      collection do
        resources :categories, controller: 'extranets/posts/categories', as: 'post_categories' do
          member do
            get :preview
          end
        end
      end
      member do
        get :preview
      end
    end
    # Automatic routes based on feature names
    get 'library' => 'extranets/documents#library', as: :library
    resources :documents, controller: 'extranets/documents' do
      collection do
        resources :categories, controller: 'extranets/documents/categories', as: 'document_categories'
        resources :kinds, controller: 'extranets/documents/kinds', as: 'document_kinds'
      end
    end
    resources :jobs, controller: 'extranets/jobs'
  end
  resources :medias do
    collection do
      post 'pick' => 'medias#pick', as: :pick
      resources :categories, controller: '/admin/communication/medias/categories', as: 'media_categories' do
        collection do
          post :reorder
        end
        member do
          get :children
        end
      end
      resources :collections, controller: '/admin/communication/medias/collections', as: 'media_collections'
    end
  end
  root to: 'dashboard#index'
end
