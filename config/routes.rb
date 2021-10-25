Rails.application.routes.default_url_options[:host] = 'localhost:3001'

Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    resources :users, only: %w[show]
    resources :athletes, only: %w[show] do
      resources :activities, only: %w[index]
    end
    resources :activities, only: %w[show index]
  end

  devise_for :users,
    defaults: { format: :json },
    path: '',
    path_names: {
      sign_in: 'api/login',
      sign_out: 'api/logout',
      registration: 'api/signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }

    get '/current_user', to: 'current_user#index'
end