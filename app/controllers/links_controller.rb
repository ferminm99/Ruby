class LinksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_link, only: [:edit, :update, :destroy]
  
    def index
      @links = current_user.links
    end
  
    def show
      @link = current_user.links.find_by(slug: params[:slug])
      
      if @link.nil? || !@link.accessible?
        redirect_to home_index_path, alert: 'Link not found'
      elsif @link.private_link?
        # Lógica para manejar la solicitud de clave
      else
        @link.increment_access_count if @link.ephemeral?
        LinkAccess.create(link: @link, accessed_at: Time.current, ip_address: request.remote_ip)
        redirect_to @link.url, allow_other_host: true
      end
    end
  
    def new
      @link = current_user.links.build
    end
  
    def edit
      @link = Link.find(params[:id])
    end  
  
    def create
      @link = current_user.links.build(link_params)
  
      if @link.save
        redirect_to home_index_path, notice: 'Link was successfully created.'
      else
        render :new
      end
    end
  
    def update
      if @link.update(link_params)
        redirect_to home_index_path, notice: 'Link was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
        @link = Link.find(params[:id])
        @link.destroy
        redirect_to home_index_path, notice: 'Link was successfully destroyed.'
    end
  
    private
  
    def set_link
      @link = current_user.links.find(params[:id])
    end
  
    def link_params
      params.require(:link).permit(:url, :link_type, :password_digest, :expiration_date)
    end
      
end  