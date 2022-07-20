Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "payment_requests#index"

  resources :payment_requests, only: [:index, :new, :create]
end
