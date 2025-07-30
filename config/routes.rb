Rails.application.routes.draw do
  post '/auth/register', to: 'auth#register'
  post '/auth/login', to: 'auth#login'
  delete '/auth/logout', to: 'auth#logout'
  
  resources :users, only: [:index, :show, :update, :destroy] do
    collection do
      get :profile
    end
  end
  
  resources :pets, only: [:index, :show, :create, :update, :destroy]
  
  resources :adoptions, only: [:index, :show, :create, :update, :destroy]
end
