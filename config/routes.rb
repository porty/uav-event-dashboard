Rails.application.routes.draw do
  root to: 'home#index'
  get '/logout', to: 'home#logout'
  resources :obc_stats, only: 'index'
  resources :events, only: 'create'
  resources :backlog_events, only: 'index'
  resources :transfer_events, only: 'index'
end
