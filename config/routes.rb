Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user/sessions'
  }

  root to: "home#index"

  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:new, :create], shallow: true
  end
end
