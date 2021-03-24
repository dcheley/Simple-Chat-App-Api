Rails.application.routes.draw do
  devise_for :users

  root to: 'chat_rooms#index'

  resources :chat_rooms
  resources :messages
  resources :users, only: [:create, :index, :show]

  namespace :api do
    namespace :v1 do
      resources :chat_rooms
      resources :messages
      resources :users, only: [:create, :index, :show, :update]
    end
  end
end
