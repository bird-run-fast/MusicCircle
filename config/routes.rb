Rails.application.routes.draw do
  root "public/posts#index"

  devise_for :endusers, path: :public, controllers: {
    sessions: 'public/devise/sessions',
    registrations: 'public/devise/registrations'
  }

  namespace :public  do
    resources :post_tags, only: [:create, :destroy]
    resources :tags
    resources :posts do
      resource :concerns, only: [:create, :destroy]
    end
    resource :endusers, only: [:show, :edit, :update]
  end
end
