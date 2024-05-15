Rails.application.routes.draw do

  get 'rooms/research' => 'rooms#research'
  post 'rooms/research' => 'rooms#research'

  resources :rooms do
    delete 'leave', on: :member
    post 'join', on: :member
  end

  resources :user do
    delete 'leave', on: :member
  end

  resources :rooms

  get '/tweets/new', to: 'tweets#new', as: 'new_tweet'

  get '/tweets/new2', to: 'tweets#new2', as: 'new2_tweet'

  get '/tweets/new3', to: 'tweets#new3', as: 'new3_tweet'

  post 'tweets/:id/edit', to: 'tweets#edit', as: 'edit_tweet'


  devise_for :users

  

  resources :users, only: [:edit]

  resources :comments, only: [:create] 

  resource :tweets

  get 'tweets/:id' => 'tweets#show',as: 'tweet'
  get 'tweets/:tweet_id/agrees' => 'agrees#create'
  get 'tweets/:tweet_id/agrees/:id' => 'agrees#destroy'
  patch 'tweets/:id' => 'tweets#update'
  patch 'tweets/:id' => 'tweets#update2'

  
  resources :tweets do
    resources :likes, only: [:create, :destroy]
    resources :agrees, only: [:create, :destroy]
    resources :resolves, only: [:create, :destroy]
    resources :comments, only: [:create]
  end

  
  #root ':tweets#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'hello#index'

  # Defines the root path route ("/")
  # root "posts#index"
end
