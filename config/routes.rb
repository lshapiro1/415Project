Rails.application.routes.draw do
  root to: "courses#index"
  resources :courses, :only => [:index, :show] do
    resources :questions, :only => [:index, :new, :create, :destroy] do
      resources :polls, :only => [:index, :show, :create, :update, :destroy] 
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
