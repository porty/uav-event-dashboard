Rails.application.routes.draw do
  resources :obc_stats, only: 'index'
  resources :events, only: 'create'
end
