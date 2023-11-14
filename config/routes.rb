Rails.application.routes.draw do
  get '/dashboard', to: 'dashboard#home'
  get '/welcome', to: 'static_pages#welcome'
  get '/profiles', to: 'profiles#index'
  get '/profiles/:id', to: 'profiles#show'
  get '/search', to: 'profiles#search'
  get 'profiles/:id/send_message', to: 'chats#send_message', as: :send_message
  get 'profiles/:id/send_message', to: 'profiles#send_message_to_profile', as: :send_message_to_profile


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
    end
  end

  resources :blocks, only: [:index, :create, :destroy]
  resources :favorites
  resources :messages
  resources :chats, only: [:index, :create, :destroy]

  resources :chats do
    resources :messages
  end

end
# ------------------------------------------------------------------------------------------------------------------------
# https://gist.github.com/withoutwax/46a05861aa4750384df971b641170407  Helpful resource for messing with devise controller
# https://github.com/ID25/rails_emoji_picker  emoji
# ------------------------------------------------------------------------------------------------------------------------
#