Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :places
  resources :varieties
  resources :orders, only: [:index, :new, :create]
  get '/orders/new/:id', to: 'orders#newOrder', as: "newOrder"
  post '/orders/create', to: 'orders#create', as: "create_order"
  get '/orders/show_order', as: "show_order"
  post '/orders/finish', to: 'orders#finish', as: 'finish_order'
end
