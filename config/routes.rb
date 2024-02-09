Rails.application.routes.draw do
  devise_for :users
  get 'registrations/new'
  get 'registrations/create'
  root to: "posts#index"

  resources :posts do
    resources :comments, only:[:create, :destroy]
  end
  #resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create edit update destroy]
  get "up" => "rails/health#show", as: :rails_health_check
end
