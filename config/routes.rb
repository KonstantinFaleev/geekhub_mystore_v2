Rails.application.routes.draw do
  resources :orders, only: [:new, :create]
  resources :line_items
  resources :carts
  root 'store#index', as: 'store_index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :products do
    get :who_bought, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
