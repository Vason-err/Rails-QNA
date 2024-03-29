require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'user/sessions'
  } do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :questions, except: [:edit] do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      member do
        post :mark_as_best
      end
    end
    resource :subscription, only: %i[create destroy]
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

  concern :commentable do |options|
    member do
      resources :comments, { only: [:create] }.merge(options)
    end
  end

  resources :questions, only: [], param: :commentable_id do
    concerns :commentable, defaults: { commentable_type: 'question' }, as: :question_comments
  end

  resources :answers, only: [], param: :commentable_id do
    concerns :commentable, defaults: { commentable_type: 'answer' }, as: :answer_comments
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
