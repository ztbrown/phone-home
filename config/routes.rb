PhoneHome::Application.routes.draw do
  devise_for :users

  resources :trackers do
    member do
      put :activate
      put :deactivate
    end
  end

  get '/images/:token', to: 'images#show', as: :images

  root to: 'trackers#index'
end
