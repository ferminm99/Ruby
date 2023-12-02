class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @links = current_user.links
  end

  def destroy
    @user = User.find(params[:id])

    # Asegúrate de que los usuarios solo puedan eliminar sus propias cuentas
    if @user == current_user
      @user.destroy
      flash[:notice] = 'Tu cuenta ha sido eliminada con éxito.'
      redirect_to root_path
    else
      flash[:alert] = 'No tienes permiso para eliminar esta cuenta.'
      redirect_to root_path
    end
  end
  
end
