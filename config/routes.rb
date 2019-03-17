Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :places
  resources :varieties
  resources :orders
  post '/orders/finish', to: 'orders#finish', as: 'finish_order'
  root 'orders#index'
end
