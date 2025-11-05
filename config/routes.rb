

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  concern :paginatable, Paginatable.new(action: :show)

  resources :expenses, except: [ :show ]
  resource :expenses, only: [] do
    concerns :paginatable, action: :index
  end

  resources :statements, except: [ :show ]
  resources :statements, only: [], concerns: :paginatable

  resources :sources, except: [ :show ]
  resources :sources, only: [], concerns: :paginatable

  resources :categories, except: [ :show ] do
    resources :subcategories, except: [ :show ]
    resources :subcategories, only: [], concerns: :paginatable
  end
  resources :categories, only: [], concerns: :paginatable
  resource :subcategory, only: [] do
    post :transfer
  end

  resources :dashboards, only: [ :index ] do
    collection do
      get :statement
      get :month # To delete
      get :year  # To delete
    end
  end

  resource :api, only: [] do
    collection do
      get :total
      get :monthly
    end
  end

  resource :api_access, path: "access", only: [ :edit, :update ] do
    collection do
      put :toogle
    end
  end

  resource :session, only: [ :new, :create, :destroy ]
  resource :password, only: [ :edit, :update ]
  resource :registration, only: [ :new, :create, :destroy ] do
    get :delete
  end

  # Defines the root path route ("/")
  root "home#index"
  get "policy" => "guest#policy", :as => :policy

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
