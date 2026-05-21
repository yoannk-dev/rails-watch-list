Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :movies, only: %w[index]
  resources :lists, only: %w[new create]
end
