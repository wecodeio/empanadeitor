Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :places do
      resources :varieties, except: [:index, :show]
    end
    root 'places#index'
  end
  resources :orders, except: [:delete] do
    get :new_custom_place, on: :collection, to: 'orders#new_custom_place'
    get :confirm, on: :member
    post :finish, on: :member
    get :join, on: :member
    post :create_join, on: :member
    post :send_order_slug, on: :collection
  end
  root 'orders#index'
end
