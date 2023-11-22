Rails.application.routes.draw do
  get '/dashboard', to: 'dashboard#home'
  get '/welcome', to: 'static_pages#welcome'
  get '/profiles', to: 'profiles#index'
  get '/profiles/:id', to: 'profiles#show'
  get '/search', to: 'profiles#search'
  get 'profiles/:id/send_message', to: 'chats#send_message', as: :send_message
  get 'profiles/:id/send_message', to: 'profiles#send_message_to_profile', as: :send_message_to_profile
  get 'favorites/:id/send_message', to: 'favorites#send_message_to_liked  ', as: :send_message_to_liked

  delete '/admin/:id', to: 'admin#destroy', as: :delete_user
  get '/admin', to: 'admin#index', as: :admin_panel
  get '/admin/:id', to: 'admin#show', as: :user_full_info
  get '/admin/:id/blocks', to: 'admin#blocks', as: :blocks_admin
  get '/admin/:id/blocked', to: 'admin#blocked', as: :blocked_admin
  get '/admin/:id/likes', to: 'admin#likes', as: :likes_admin
  get '/admin/:id/liked', to: 'admin#liked', as: :liked_admin
  get '/admin/:id/chats', to: 'admin#chats', as: :chats_admin
  get '/admin/:user_id/chats/:chat_id', to: 'admin#messages', as: :messages_admin

  devise_for :users

  # root route for authenticated users
  authenticated :user do
    root "profiles#index", as: :authenticated_root
  end

  # landing page if you are not logged in
  root "static_pages#welcome"

  resources :profiles do
    member do
      post 'block'
      delete 'unblock'
      post 'like'
      delete 'unlike'
    end
  end

  resources :blocks, only: [:index, :create, :destroy]
  resources :favorites
  resources :messages, only: [:create, :destroy]
  resources :chats, only: [:index, :create, :destroy]

  resources :chats do
    resources :messages, only: [:create, :destroy]
  end

end
# ------------------------------------------------------------------------------------------------------------------------
# https://gist.github.com/withoutwax/46a05861aa4750384df971b641170407  Helpful resource for messing with devise controller
# https://github.com/ID25/rails_emoji_picker  emoji
# reset the last two commits
# ------------------------------------------------------------------------------------------------------------------------
#