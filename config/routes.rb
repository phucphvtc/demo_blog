Rails.application.routes.draw do
  resources :users
  resources :posts
  resources :builds
  
  get '/check',to: 'builds#check'
  post '/login', to: 'sessions#login'
  get '/confirm', to: 'users#confirm'
  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  resources :posts do
    post '/like', to: 'likes#create'
    get '/like', to: 'likes#show'
    
  end

  resources :comments do
    post 'like', to: 'likes#create'
    get '/like', to: 'likes#show'
  end
end
