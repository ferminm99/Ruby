Rails.application.routes.draw do
  # Define la ruta raíz
  root 'home#index'

  # Rutas de Devise para usuarios
  devise_for :users

  # Otras rutas
  get 'home/index', as: 'home_index'
  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :links, except: [:show, :destroy]
  get '/links/:slug', to: 'links#show', as: :link_show
  delete '/links/:id', to: 'links#destroy', as: :link_destroy
  get '/links/:id/report', to: 'links#report', as: :link_report
  # ... cualquier otra ruta que necesites
end
