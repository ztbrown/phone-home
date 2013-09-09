PhoneHome::Application.routes.draw do
  devise_for :users

  resources :trackers do
    member do
      put :activate
      put :deactivate
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :tokens, only: [:create] do
        delete :destroy, on: :collection
      end
      resources :trackers do
        member do
          put :activate
          put :deactivate
        end
      end
    end
  end


  get '/images/:token', to: 'images#show', as: :images

  root to: 'trackers#index'
end
