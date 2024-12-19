namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  # v0
  get 'osuny' => '/api/osuny#redirect_to_v1' # redirect to v1
  post 'osuny/websites/theme-released' => '/api/osuny/server/websites#theme_released', defaults: {format: :json}
  # v1
  namespace :osuny, path: 'osuny/v1', defaults: { format: :json } do
    namespace :communication do
      resources :websites, only: [:index, :show] do
        namespace :agenda do
          resources :events, controller: '/api/osuny/websites/agenda/events', only: [:index, :show, :create, :update, :destroy] do
            post :upsert, on: :collection
          end
        end
        resources :pages, controller: '/api/osuny/websites/pages', only: [:index, :show, :create, :update]
        resources :posts, controller: '/api/osuny/websites/posts', only: [:index, :show, :create, :update, :destroy] do
          post :upsert, on: :collection
        end
        resources :projects, controller: '/api/osuny/websites/projects', only: [:index, :show, :create, :update]
      end
      root to: '/api/osuny/communication#index'#, controller: '/api/osuny/communication'
    end
    root to: '/api/osuny#index'
  end
  root to: 'dashboard#index'
end
