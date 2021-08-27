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
  resources :rewards, only: :index

  concern :voteable do |options|
    member do
      resources :votes, { only: [:create] }.merge(options)
    end
  end

  resources :questions, only: [], param: :voteable_id do
    concerns :voteable, defaults: { voteable_type: 'question' }, as: :question_votes
  end

  resources :answers, only: [], param: :voteable_id do
    concerns :voteable, defaults: { voteable_type: 'answer' }, as: :answer_votes
  end

  resources :votes, only: [:destroy]
end
