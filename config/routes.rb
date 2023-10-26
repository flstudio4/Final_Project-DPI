Rails.application.routes.draw do
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/search', to: 'search#index'

  devise_for :users
  
  root "static_pages#home"

  resources :blocks
  resources :favorites
  resources :messages
  resources :chats

end
