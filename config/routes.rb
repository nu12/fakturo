Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Expenses
  get "/expenses/page/:page" => "expenses#index", :as => :expenses_page
  get "/expenses/page/:page/:id" => "expenses#show", :as => :expense_page
  get "/expenses/renderform/:id" => "expenses#render_form", :as => :expense_render_form
  resources :expenses, except: [ :show, :edit ]

  # Statements
  resources :statements, except: [ :show ]
  get "/statements/:id(/page/:page)" => "statements#show", :as => :statement_page

  # Sources
  resources :sources, except: [ :show ]
  get "/sources/:id(/page/:page)" => "sources#show", :as => :source_page

  # Categories and sub-categories
  resources :categories, except: [ :show ] do
    resources :subcategories, except: [ :show ]
  end
  get "/categories/:category_id/subcategories/:id(/page/:page)" => "subcategories#show", :as => :category_subcategory_page
  get "/categories/:id(/page/:page)" => "categories#show", :as => :category_page
  post "/subcategories/transfer" => "subcategories#transfer", :as => :subcategories_transfer

  # Anonymous access
  get "policy" => "guest#policy"

  # User navigation
  get "home" => "home#index"
  get "home/policy" => "home#policy"

  # Dashboards
  get "dashboards" => "dashboards#index", :as => :dashboards
  get "dashboards/category_by_statement", as: :category_by_statement
  get "dashboards/category_by_month", as: :category_by_month
  get "dashboards/category_by_year", as: :category_by_year

  # API
  get "api/total"
  get "api/monthly"

  resource :api_access, :path => "access", only: [ :edit, :update ] do
    collection do
      put :toogle
    end
  end
  resource :session, only: [ :new, :create, :destroy ]
  resource :password, only: [ :edit, :update ]
  resource :registration, only: [ :new, :create, :destroy ] do
    collection do
      get :delete
    end
  end

  # Defines the root path route ("/")
  root "home#index"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
