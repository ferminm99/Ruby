Rails.application.routes.draw do
  # Define la ruta raíz
  root 'home#index'

  # Rutas de Devise para usuarios
  devise_for :users, controllers: { registrations: 'registrations' }

  # Otras rutas
  get 'home/index', as: 'home_index'
  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :links, except: [:show]
  get '/links/:slug', to: 'links#follow', as: :shortened
  get '/links/:id/report', to: 'links#report', as: :link_report
  post 'links/:id/verificar_clave', to: 'links#verificar_clave', as: 'verificar_clave_link'
  get 'links/:id/password_form', to: 'links#password_form', as: 'password_form_link'

  # ... cualquier otra ruta que necesites
end
