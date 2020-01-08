Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, :controllers => { :registrations => "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: "static_pages#index"
  get "/about", to: "static_pages#about"

  resources :users
  resources :news, only: %i(index show)
  resources :services
  resources :schedules, only: %i(index show)
  resources :tasks, only: %i(index destroy)
  resources :vendors
  resources :service_of_vendors
end
