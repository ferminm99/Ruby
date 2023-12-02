class LinksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_link, only: [:edit, :update, :destroy]
  
    def index
      @links = current_user.links
    end
  
    def show
        
      @link = Link.find_by(slug: params[:slug])
      logger.debug "Accediendo a la acción show"
      logger.debug "Accediendo a la acción show"

      logger.debug "Slug recibido: #{params[:slug]}"
      logger.debug "Usuario actual: #{current_user.id}"

      if @link.nil?
        logger.debug "Link no encontrado"
        redirect_to home_index_path, alert: 'Link not found'
        return
      end
    
      if !@link.accessible?(request)
        if @link.temporal? && @link.expired?
            render status: :not_found # O redirigir a una página de error 404 personalizada
        else
            redirect_to alguna_ruta_error_path, alert: 'Link not accessible'
        end
        if @link.ephemeral?
            render status: :forbidden # O redirigir a una página de error 403 personalizada
            return
        end
        return  
    #   if @link.nil? || !@link.accessible?(request)
    #     logger.debug "NO ENCONTRO NADA"
    #     redirect_to home_index_path, alert: 'Link not found'
      elsif @link.private_link?
        if !@link.accessible?(request)
            redirect_to solicitar_clave_link_path(@link)
            return
        end
        # Lógica para manejar la solicitud de clave
      else
        @link.increment_access_count
        @link.increment!(:access_count)
        logger.debug "SE CREO?!?!?"
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


     def report
        @link = Link.find(params[:id])
        @accesses = @link.link_accesses.order(accessed_at: :desc)

        if params[:start_date].present?
        @accesses = @accesses.where('accessed_at >= ?', params[:start_date])
        end

        if params[:end_date].present?
        @accesses = @accesses.where('accessed_at <= ?', params[:end_date])
        end

        if params[:ip_address].present?
        @accesses = @accesses.where(ip_address: params[:ip_address])
        end
    end
  
    private
  
    def set_link
      @link = current_user.links.find(params[:id])
    end
  
    def link_params
      params.require(:link).permit(:url, :link_type, :password_digest, :expiration_date)
    end
      
end  