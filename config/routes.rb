Rails.application.routes.draw do
  root "public/posts#index"

  devise_for :endusers, path: :public, controllers: {
    sessions: 'public/devise/sessions',
    registrations: 'public/devise/registrations'
  }

  namespace :public  do
    get 'searches/index'
    resources :post_tags, only: [:create, :destroy]
    resources :tags
    resources :posts do
      resource :concerns, only: [:create, :destroy]
      resource :comments, only: [:create]
    end
    resource :endusers, only: [:show, :edit, :update]
    resources :rooms, only: [:create, :show]
    resources :messages, only: [:create]
  end
end
