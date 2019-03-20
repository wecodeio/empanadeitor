Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :places do
      resources :varieties, except: [:index, :show]
    end
    root 'places#index'
  end
  resources :orders do
    post :finish, on: :member
    #post :new_custom_place, on: :member, to: 'orders#new'
  end
  post 'orders/new_custom_place', to:'orders#new', as: 'new_custom_place_order'
  root 'orders#index'
end
