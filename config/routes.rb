Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  # Authentication routes
  post '/auth/login', to: 'authentication#login'
  post '/auth/register', to: 'authentication#register'
  # Posts and comments routes
  resources :posts do
    resources :comments
  end
  
  # Tags routes
  resources :tags, only: [:index, :show]
  
  # User profile
  get '/profile', to: 'users#profile'
  
  # Health check for Docker
  get '/health', to: proc { [200, {}, ['ok']] }