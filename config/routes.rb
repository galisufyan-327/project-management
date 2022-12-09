Rails.application.routes.draw do
  devise_for :users

  root 'dashboard#index'
  resources :projects do
  	resources :tasks
  end
  resources :tasks
end
