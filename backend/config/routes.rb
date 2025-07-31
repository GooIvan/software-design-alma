Rails.application.routes.draw do
  get "profile/show"

  scope "(:locale)", locale: /en|es/ do
    # Rutas de Devise
    devise_for :users
    get "profile", to: "profile#show"

    # Rutas adicionales
    get "home", to: "home#index"
    root "home#index"

    namespace :admin do
      resource :home_video, only: [:edit, :update]
      delete 'home_video/delete_all', to: 'home_video#delete_all', as: 'delete_all_home_video'
      get "dashboard", to: "dashboard#index"
      patch 'update_home_video', to: 'dashboard#update_home_video', as: :update_home_video

      delete 'users/bulk_delete', to: 'users#bulk_delete', as: :bulk_delete_admin_users
      resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]

      resources :categories, param: :slug do
        resources :products
      end
    end

    resources :categories, param: :slug do
      resources :products, only: [:index, :show]
    end
  end

  # 🛒 Carrito
  resources :cart_items, only: [:create, :destroy, :update]

  resource :cart, only: [:show] do
    resources :cart_items, only: [:update, :destroy]
  end

  resources :cart_items do
    patch :update_quantity, on: :member
  end

  # ✅ API para Flutter
  namespace :api do
    resources :products, only: [:index, :show]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
