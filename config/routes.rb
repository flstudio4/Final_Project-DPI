Rails.application.routes.draw do
  get '/dashboard', to: 'dashboard#home'
  get '/welcome', to: 'static_pages#welcome'
  get '/profiles', to: 'profiles#index'
  get '/profiles/:id', to: 'profiles#show'

  devise_for :users

  # root route for authenticated users
  authenticated :user do
    root "dashboard#home", as: :authenticated_root
  end

  # landing page if you are not logged in
  root "static_pages#welcome" 

  resources :blocks
  resources :favorites
  resources :messages
  resources :chats

end
# ------------------------------------------------------------------------------------------------------------------------
# https://gist.github.com/withoutwax/46a05861aa4750384df971b641170407  Helpful resource for messing with devise controller
# ------------------------------------------------------------------------------------------------------------------------
#