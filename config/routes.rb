Rails.application.routes.draw do
  # Define la ruta raíz
  root 'home#index'

  # Rutas de Devise para usuarios
  devise_for :users

  # Otras rutas
  get 'home/index', as: 'home_index'
  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :links, except: [:show]
  get '/links/:slug', to: 'links#show', as: :link_show

  # ... cualquier otra ruta que necesites
end
