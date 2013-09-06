PhoneHome::Application.routes.draw do
  devise_for :users

  resources :trackers

  get '/images/:token', to: 'images#show', as: :images

  root to: 'trackers#index'
end
