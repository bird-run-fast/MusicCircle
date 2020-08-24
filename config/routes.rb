Rails.application.routes.draw do
  root "public/posts#index"

  devise_for :admins, controllers: {
    sessions: 'admins/devise/sessions'
  }

  devise_for :endusers, path: :public, controllers: {
    sessions: 'public/devise/sessions',
    registrations: 'public/devise/registrations'
  }

  namespace :admins do
    resources :endusers, only: [:destroy]
    resources :batches, only: [:index]
    get "batches/score" => "batches#score"
    resources :charts, only: [:index]
  end

  namespace :public  do
    get 'searches/index'
    resources :post_tags, only: [:create, :destroy]
    resources :tags
    resources :posts do
      resource :concerns, only: [:create, :destroy]
      resource :comments, only: [:create]
    end
    resource :endusers, only: [:show, :edit, :update]
    get 'endusers/dmshow' => 'endusers#dmshow'
    get 'endusers/chart' => 'endusers#chart'
    resources :rooms, only: [:create, :show]
    resources :messages, only: [:create]
    resources :notifications, only: [:index]
    resources :chart_sample, only: [:index]
  end
end
