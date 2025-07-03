Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create]
  resources :pets, only: [:index, :show, :create]
  resources :adoptions, only: [:index, :show, :create, :update]
end
