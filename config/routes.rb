Rails.application.routes.draw do
  root 'home#index'
  resources :searches, only: :index
  resources :articles, only: :index
end
