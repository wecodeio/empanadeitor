Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :places
  resources :varieties
  resources :orders, only: [:index, :new, :create]
  get '/orders/new/:id', to: 'orders#newOrder', as: "newOrder"
  post '/orders/new/:id', to: 'orders#create'
end
