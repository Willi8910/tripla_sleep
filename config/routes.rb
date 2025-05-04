Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :clock_in, only: %i[create index]
end
