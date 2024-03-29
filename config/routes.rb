Rails.application.routes.draw do
  resources :games
  resources :friends
  resources :profiles
  devise_for :users

  resources :messages do
    collection do
      get 'received'
      get 'sent'
    end
    member do
      delete :destroy
    end
  end

  resources :invitations, only: %i[index new create] do
    collection do
      get 'received'
      get 'accepted'
    end
    member do
      get 'accept'
      get 'decline'
    end
  end


  resources :ranking, only: [:index]

  get '/ranking', to: 'ranking#index'

  root 'pages#home'
end
