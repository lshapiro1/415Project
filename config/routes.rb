Rails.application.routes.draw do
  root to: "courses#index"
  resources :courses, :only => [:index, :show] do
    resources :questions, :only => [:index, :new, :create] do
      resources :polls, :only => [:index] 
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
