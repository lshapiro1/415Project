Rails.application.routes.draw do
  root to: "courses#index"
  resources :courses, :only => [:index, :show]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
