Rails.application.routes.draw do
  # Ruta para el health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Rutas sin localización
  resources :cart_items, only: [:create, :destroy, :update] do
    patch :update_quantity, on: :member
  end

  resource :cart, only: [:show] do
    resources :cart_items, only: [:update, :destroy]
  end

  # Rutas de prueba/directas (mejor eliminar si no se usan)
  # get "orders/create"   => ⚠️ duplicada o innecesaria si usas resources
  # get "orders/show"
  # get "profile/show"    => reemplazada abajo por `get "profile"`

  # Rutas con localización
  scope "(:locale)", locale: /en|es/ do
    # Devise
    devise_for :users

    # Página de perfil
    get "profile", to: "profile#show"

    # Página de inicio
    get "home", to: "home#index"
    root "home#index"

    # Rutas administrativas
    namespace :admin do
      # Dashboard
      get "dashboard", to: "dashboard#index"
      patch "update_home_video", to: "dashboard#update_home_video", as: :update_home_video

      # HomeVideo
      resource :home_video, only: [:edit, :update]
      delete "home_video/delete_all", to: "home_video#delete_all", as: :delete_all_home_video

      # Users
      delete "users/bulk_delete", to: "users#bulk_delete", as: :bulk_delete_admin_users
      resources :users

      # Categorías y productos (admin)
      resources :categories, param: :slug do
        resources :products
      end

      # Órdenes (admin)
      delete "orders/bulk_delete", to: "orders#bulk_delete", as: :bulk_delete_admin_orders
      resources :orders
    end

    # Categorías y productos (público)
    resources :categories, param: :slug do
      resources :products, only: [:index, :show]
    end

    # Órdenes (usuario)
    resources :orders, only: [:create, :show]
  end
end
