Rails.application.routes.draw do
  get 'users/show'
  devise_for :users

  resources :users, only: [:show] do
    member do
      get :edit_avatar
      patch :update_avatar
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"

  get "home" => "pages#home"
end
