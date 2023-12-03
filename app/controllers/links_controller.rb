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
        logger.debug "Inaccesible"
        if @link.temporal?
            render 'errors/404', status: :not_found # O redirigir a una página de error 404 personalizada
            return # Asegúrate de no ejecutar más código después
        end
        if @link.ephemeral?
            render 'errors/403', status: :not_found # O redirigir a una página de error 404 personalizada
            return # Asegúrate de no ejecutar más código después
        end
        if @link.private_link?
            render status: :forbidden # O redirigir a una página de error 403 personalizada
            return
        end
        return  
    #   if @link.nil? || !@link.accessible?(request)
    #     logger.debug "NO ENCONTRO NADA"
    #     redirect_to home_index_path, alert: 'Link not found'
      elsif @link.private_link?
            if session[:"link_#{params[:id]}_authenticated"].blank? 
                @link.increment_access_count
                @link.increment!(:access_count)
                LinkAccess.create(link: @link, accessed_at: Time.current, ip_address: request.remote_ip)
                redirect_to @link.url, allow_other_host: true
            else
                logger.debug "Error al autenticar algo de link?"
                redirect_to home_index_path
            end
            
            return
        # Lógica para manejar la solicitud de clave
      else
        @link.increment_access_count
        @link.increment!(:access_count)
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

        # Filtrado basado en la forma (si se envían parámetros)
        start_date = params[:start_date].presence || Date.today
        end_date = params[:end_date].presence || Date.today
        ip_address = params[:ip_address]

        query = @link.link_accesses.where(accessed_at: start_date.beginning_of_day..end_date.end_of_day)
        query = query.where(ip_address: ip_address) if ip_address.present?

        # Agrupando y contando accesos por día
        @daily_accesses = query.group("DATE(accessed_at)").count
    end
  
    def solicitar_clave
        @link = Link.find(params[:id])
    end

    def verificar_clave
        @link = Link.find(params[:id])
        if @link.authenticate(params[:password])
          # Si la contraseña es correcta, guarda una señal en la sesión y redirige al link
          session[:"link_#{params[:id]}_authenticated"] = true
          redirect_to shortened_path(@link.slug)
        else
          # Si la contraseña es incorrecta, redirige de nuevo al formulario con un mensaje de error
          redirect_to home_index_path, alert: "Contraseña incorrecta"
        end
      end

    private
  
    def set_link
      @link = current_user.links.find(params[:id])
    end
  
    def link_params
      params.require(:link).permit(:url, :link_type, :password, :expiration_date)
    end
      
end  