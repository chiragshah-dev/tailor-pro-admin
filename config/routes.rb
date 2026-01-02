Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :admin_users,
             path: "admin",
             controllers: {
               sessions: "admin/sessions",
             }

  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "admin/dashboard#index"
  namespace :admin do
    resources :users
    resources :currency_settings
    resources :stores
    resources :workers
    resources :garment_types
    resources :measurement_fields
    resources :currencies do
      resources :currency_countries, only: %i[new create destroy]
    end
    resources :orders, only: [:index, :show]
    resources :order_items, only: [:show]
    get "stores/:id/stitches_for", to: "orders#store_stitches_for"
    get "garment_types/by_gender/:gender", to: "orders#garment_types_by_gender"
    get "garment_types/:id/measurement_fields", to: "orders#measurement_fields"
  end
end
