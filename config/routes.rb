Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'user/sessions'
  }

  resources :questions, only: [:index, :show, :new, :create, :destroy] do
    resources :answers, only: [:create, :destroy], shallow: true
  end
end
