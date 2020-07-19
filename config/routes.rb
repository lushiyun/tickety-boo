Rails.application.routes.draw do
  resources :tickets do
    resources :comments, only: %i[create edit update destroy]
    member do
      post :toggle_status
    end
  end

  resources :posts

  resources :topics, only: %i[index show]

  devise_for :users, path: '',
                     path_names: {
                       sign_in: 'signin',
                       sign_out: 'logout',
                       sign_up: 'signup'
                      },
                     controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :users do
    authenticated do
      root 'tickets#index', as: :user_root
    end

    unauthenticated do
      root 'pages#home'
    end
  end
end
