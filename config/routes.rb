Rails.application.routes.draw do
  resources :games
  root 'pages#home'
  devise_for :users
end

