Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'users#index'
  get '/users/current', to: 'users#current'

  resources :users, only: [:edit, :update, :destroy]
end
