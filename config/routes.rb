Rails.application.routes.draw do
  get '/home', to: 'home#home'
  get '/welcome', to: 'static_pages#welcome'
  get '/search', to: 'search#index'

  devise_for :users

  # root route for authenticated users
  authenticated :user do
    root "home#home", as: :authenticated_root 
  end

  # landing page if you are not logged in
  root "static_pages#welcome" 

  resources :blocks
  resources :favorites
  resources :messages
  resources :chats

end
