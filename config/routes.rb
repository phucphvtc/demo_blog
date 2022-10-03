Rails.application.routes.draw do
  resources :users
  resources :posts
  resources :builds

  post '/login', to: 'sessions#login'

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end
end
