Rails.application.routes.draw do
  get 'user_leaderboard/index'

  root 'landing_page#welcome'

  devise_for :users,
              controllers: {
                registrations: 'users/registrations'
              }

  devise_scope :user do
     get 'users/profile', to: 'users/registrations#profile', as: :current_user_profile
     get 'users/:id', to: 'users/registrations#show', as: :user_profile
  end

  resources :dares, only: [:create, :destroy, :new, :show]
  resources :dare_submissions,          only: [:create, :edit, :destroy, :new, :update, :transfer_karma]
  get 'dares/', to: 'dares#index', as: :show_dare_list
  post 'dare_submissions/transfer_karma', to: "dare_submissions#transfer_karma"
  resources :comment_likes 
  resources :submission_likes 
  resources :comments, only: [:create, :destroy]
  resources :user_leaderboard, only: [:index]
  
  get 'leaderboard/', to: 'user_leaderboard#index', as: :show_leaderboard
  
end
