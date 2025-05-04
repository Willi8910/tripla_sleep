require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :clock_in, only: %i[create index]

  resources :users, only: [] do
    member do
      post 'follow'
      delete 'unfollow'
    end
  end
end
