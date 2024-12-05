Rails.application.routes.draw do
  get "addresses/new"
  get "addresses/create"
  # devise_for :users
  # Admin routes
  devise_for :users, path: "admin", controllers: {
    sessions: "admin/sessions"
  }, as: "admin"

  # Frontend routes
  devise_for :users, path: "frontend", controllers: {
    sessions: "frontend/sessions"
  }, as: "frontend"

  # Admin routes
  namespace :admin do
    get "provinces/index"
    get "provinces/edit"
    get "provinces/update"
    root "dashboard#index"
    resources :products, only: [ :index, :new, :create, :edit, :update, :destroy ]
    resources :orders, only: [ :index, :show, :edit, :update ]
    resources :users, only: [ :index ]
    resources :categories
    resources :provinces, only: [ :index, :edit, :update ]
  end

  # Frontend routes
  root "home#index"
  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]
  resources :orders, only: [ :index, :new, :create, :show ]
  resources :cart, only: [ :index ] do
    post "add", on: :collection  # This creates the `add_cart_index_path`
    patch "update_quantity", on: :collection
    delete "remove", on: :collection
  end

  resources :users, only: [] do
    resource :address, only: [ :new, :create, :edit, :update ] # Address belongs to user, edit and update actions
  end

  resources :checkouts, only: [ :index, :create ] do
    member do
      get :invoice
    end
  end


  # Health check route and PWA files
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
