Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show] do
    resources :lists
  end

  root 'main#index'
end
