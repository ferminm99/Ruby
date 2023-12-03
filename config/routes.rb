Rails.application.routes.draw do
  # Define la ruta raíz
  root 'home#index'

  # Rutas de Devise para usuarios
  devise_for :users, controllers: { registrations: 'registrations' }

  # Otras rutas
  get 'home/index', as: 'home_index'
  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :links, except: [:show, :destroy]
  get '/links/:slug', to: 'links#show', as: :shortened
  delete '/links/:id', to: 'links#destroy', as: :link_destroy
  get '/links/:id/report', to: 'links#report', as: :link_report
  post 'links/:id/verificar_clave', to: 'links#verificar_clave', as: 'verificar_clave_link'

  # ... cualquier otra ruta que necesites
end
