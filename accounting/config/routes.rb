Rails.application.routes.draw do
  root "dashboard#index"

  get :login, to: 'sessions#index', as: :login
  get :logout, to: 'sessions#destroy', as: :logout

  get ':user_id/auditlogs', to: 'auditlogs#index', as: :auditlog

  get '/auth/:provider/callback', to: 'sessions#create'
end
