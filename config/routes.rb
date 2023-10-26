Rails.application.routes.draw do
  devise_for :users
  
  root "static_pages#home"

  resources :blocks
  resources :favorites
  resources :messages
  resources :chats
end
