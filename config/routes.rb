Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  resources :lists

  root 'main#index'
end
