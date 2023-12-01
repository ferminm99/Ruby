class ApplicationController < ActionController::Base
    # ...
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
  
    # Método para redirigir después de iniciar sesión
    def after_sign_in_path_for(resource)
      home_index_path # Asume que tienes una ruta llamada home_index_path
    end
  
    # Método para redirigir después de cerrar sesión
    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path # Lleva al usuario a la pantalla de inicio de sesión
    end
  
    # ...
  end