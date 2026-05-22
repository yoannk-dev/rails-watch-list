Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "movies#index"

  resources :movies, only: %w[index]
  resources :lists, only: %w[new create index show] do
    resources :bookmarks, only: %w[new create]
  end

  resources :bookmarks, only: %i[create destroy]
end
