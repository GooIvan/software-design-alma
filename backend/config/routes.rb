Rails.application.routes.draw do
  # 🚨 Health check
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /en|es/ do
    # 🔐 Devise
    devise_for :users

    # 👤 Perfil
    get "profile", to: "profile#show"

    # 🏠 Home
    get "home", to: "home#index"
    root "home#index"

    # 🛍️ Vista web: Productos más populares (basado en ventas pagadas)
    get "most_popular", to: "most_popular#index", as: :most_popular

    # === API para Flutter ===
    namespace :api do
      # 🛒 Productos
      resources :products, only: [:index, :show] do
        collection do
          get :latest
          get :most_popular, to: "products#most_popular"
        end
      end

      # 🏷️ Categorías
      resources :categories, param: :slug, only: [:index, :show] do
        resources :products, only: [:index, :show]
      end
    end

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

      resources :categories, param: :slug do
        resources :products
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
  end
end
