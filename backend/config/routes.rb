Rails.application.routes.draw do
  get "invoices/index"
  get "invoices/show"
  # 🚨 Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # === Data Deletion endpoints (para Facebook OAuth) ===
  get "data-deletion/instructions", to: "data_deletion#instructions"
  post "data-deletion/callback", to: "data_deletion#callback"
  get "data-deletion/status", to: "data_deletion#status"

  # === OmniAuth callbacks (FUERA del scope para evitar errores) ===
  devise_for :users, only: :omniauth_callbacks,
            controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # === API para Flutter (sin locale) ===
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'auth/google', to: 'auth#google_login'
    end

    namespace :auth do
      devise_for :users,
        path: "",
        skip: [:confirmations, :unlocks, :omniauth_callbacks],
        controllers: {
          registrations: "api/auth/registrations",
          sessions: "api/auth/sessions",
          passwords: "api/auth/passwords",
        }
    end

    resource :profile, only: [:show, :edit, :update], controller: "profile"
    resource :profile, only: [:show, :update], controller: "profile"

    # Logout endpoint
    post :logout, to: "logout#create"

    # 🛒 Productos
    resources :products, only: [:index, :show] do
      collection do
        get :latest
      end
    end

    # 🏷️ Categorías
    resources :categories, param: :slug, only: [:index, :show] do
      resources :products, only: [:index, :show]
    end

    # 📦 Órdenes API
    resources :orders, only: [:index, :show, :create] do
      member do
        patch :cancel
        patch :update_status
        get :payment_methods
      end

      collection do
        get :history
        get :active
      end
    end

    # 🏷️ Códigos de descuento API
    resources :discount_codes, only: [] do
      collection do
        post :validate
        get :available
      end
    end

    # ⭐ Favoritos API
    match "/favorites", to: "favorites#options", via: [:options]
    resources :favorites, only: [:index, :create, :destroy]

    # 💳 Pagos PayU API
    namespace :payments do
      post :create_payment_intent, to: "payments#create_payment_intent"
      post :process_payu_payment, to: "payments#process_payu_payment"
      get :payment_status, to: "payments#status"

      # Webhook de PayU
      post :payu_webhook, to: "payments#payu_webhook"
    end
    
    get 'dashboard', to: 'dashboard#index'
  end

  scope "(:locale)", locale: /en|es/ do
    # 🔐 Devise (sin omniauth_callbacks porque ya está fuera del scope)
    devise_for :users, skip: :omniauth_callbacks

    # 👤 Perfil
    resource :profile, only: [:show, :edit, :update], controller: "profile"

    # Favoritos
    resources :favorites, only: [:index, :create, :destroy]

    # 🏠 Home
    get "home", to: "home#index"
    root "home#index"

    # 🛍️ Vista web: Productos más populares (basado en ventas pagadas)
    get "most_popular", to: "most_popular#index", as: :most_popular

    # 🛒 Carrito
    resources :cart_items, only: [:create, :destroy, :update] do
      patch :update_quantity, on: :member
    end

    resource :cart, only: [:show] do
      resources :cart_items, only: [:update, :destroy]
    end

    # 🛠️ Admin
    namespace :admin do
      get "dashboard", to: "dashboard#index"
      patch "update_home_video", to: "dashboard#update_home_video", as: :update_home_video

      resource :home_video, only: [:edit, :update]
      delete "home_video/delete_all", to: "home_video#delete_all", as: :delete_all_home_video

      delete "users/bulk_delete", to: "users#bulk_delete", as: :bulk_delete_admin_users
      resources :users

      delete "orders/bulk_delete", to: "orders#bulk_delete", as: :bulk_delete_admin_orders
      resources :orders

      delete "invoices/bulk_delete", to: "invoices#bulk_delete", as: :bulk_delete_admin_invoices
      resources :invoices do
        member do
          get :download
          patch :mark_as_sent
          patch :mark_as_paid
          patch :regenerate
        end
      end

      resources :categories, param: :slug do
        resources :products
      end

      resources :discount_codes, only: [:index, :new, :create, :edit, :update, :destroy] do
        collection do
          post :validate
        end
      end
    end

    # 🛍️ Público: categorías y productos
    resources :categories, param: :slug do
      resources :products, only: [:index, :show]
    end

    # 📦 Órdenes
    resources :orders do
      member do
        get :payment
        get :pay_with_card
        post :pay_with_card
        get :success, to: "payments#success", as: :payment_success
        post :confirmation, to: "payments#confirmation", as: :payment_confirmation
      end
    end

    # 🧾 Facturas
    resources :invoices, only: [:index, :show] do
      member do
        get :download
      end
    end
  end
end
