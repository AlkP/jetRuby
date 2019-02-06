Rails.application.routes.draw do
  root to: 'appointments#index'

  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout' }

  resources :appointments
  resources :app_api

  get '/new_token', to: 'users#new_token', as: 'generate_token'
  get '/show_token', to: 'users#show_token', as: 'show_token'

  get '/request_remind/:id', to: 'appointments#request_remind' ,as: 'request_remind'
  post '/request_remind/:id', to: 'appointments#create_remind'

end
