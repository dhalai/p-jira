Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks

  get :login, to: 'sessions#index', as: :login
  get :logout, to: 'sessions#destroy', as: :logout

  get '/auth/:provider/callback', to: 'sessions#create'
end
