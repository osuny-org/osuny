namespace :education do
  resources :teachers, only: [:index, :show, :edit, :update], path: '/:lang/teachers'
  resources :schools, path: '/:lang/schools' do
    resources :roles, controller: 'schools/roles' do
      resources :people, controller: 'schools/roles/people', only: [:destroy] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
  end
  resources :programs, path: '/:lang/programs' do
    resources :roles, controller: 'programs/roles' do
      resources :people, controller: 'programs/role/people', only: [:destroy] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
    resources :teachers, controller: 'programs/teachers', except: :show do
      collection do
        post :reorder
      end
    end
    collection do
      get :tree
      post :reorder
    end
    member do
      get :children
      get :preview
      get :static
    end
  end
  resources :academic_years
  resources :cohorts, only: [:index, :show]
  resources :diplomas, path: '/:lang/diplomas' do
    member do
      get :static
    end
  end
  root to: 'dashboard#index'
end
