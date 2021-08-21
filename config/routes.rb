Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'user/sessions'
  }

  resources :questions, except: [:edit] do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :files, only: [:destroy]
  resources :links, only: :destroy
end
