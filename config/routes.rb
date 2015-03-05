Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  resources :lists do
    resources :collaborations, only: [:index, :create]
  end
  resources :collaborations, only: [:destroy]

  root 'main#index'
end
