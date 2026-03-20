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
    concern :historyable do
      member do
        get :history
      end
    end
    resources :contact_supports, only: [:index, :show, :destroy], concerns: :historyable do
      member do
        patch :close
      end
    end

    resources :roles, concerns: :historyable

    resources :contact_infos, concerns: :historyable

    resources :users, concerns: :historyable
    resources :currency_settings, concerns: :historyable
    resources :stores, concerns: :historyable
    resources :workers, concerns: :historyable
    resources :garment_types, concerns: :historyable do
      member do
        get :edit_combo
        patch :update_combo
      end
      collection do
        get :new_garment_type_combo
      end
    end
    resources :measurement_fields, concerns: :historyable
    resources :currency_countries, concerns: :historyable
    resources :currencies, concerns: :historyable do
      resources :currency_countries, only: %i[new create destroy], concerns: :historyable
    end
    resources :orders, only: [:index, :show], concerns: :historyable do
      resources :order_payments, only: [:index], as: :payments, concerns: :historyable
    end
    resources :order_items, only: [:show], concerns: :historyable
    resources :order_measurements, only: [:show], concerns: :historyable
    resources :customers, only: [:index, :show], concerns: :historyable
    resources :job_roles, concerns: :historyable
    resources :wallets, only: [:index, :show], concerns: :historyable
    resources :wallet_transactions, concerns: :historyable
    resources :notification_templates, concerns: :historyable
    resources :system_notifications, concerns: :historyable
    resources :tailor_enquiries, only: [:index, :show, :destroy]
    resources :store_measurement_fields, only: [:index, :show, :destroy], concerns: :historyable
    get "stores/:id/stitches_for", to: "orders#store_stitches_for"
    get "garment_types/by_gender/:gender", to: "orders#garment_types_by_gender"
    get "garment_types/:id/measurement_fields", to: "orders#measurement_fields"
  end
end
