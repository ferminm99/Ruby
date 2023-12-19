class LinksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_link, only: [:edit, :update, :destroy]
    skip_before_action :authenticate_user!, only: [:follow, :verificar_clave, :password_form]

    def index
      @links = current_user.links
    end
  
    def follow
        
      @link = Link.find_by(slug: params[:slug])

      if @link.nil?
        redirect_to home_index_path, alert: 'Link not found'
        return
      end
    
      if !@link.accessible?(request)
        if @link.temporal?
            render 'errors/404', status: :not_found # O redirigir a una página de error 404 personalizada
            return # Asegúrate de no ejecutar más código después
        end
        if @link.ephemeral?
            render 'errors/403', status: :forbidden # O redirigir a una página de error 404 personalizada
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
        redirect_to password_form_link_path(@link)
        # Lógica para manejar la solicitud de clave
      else
        @link.increment!(:access_count)
        LinkAccess.create(link: @link, accessed_at: Time.current, ip_address: request.remote_ip)
        redirect_to @link.url, allow_other_host: true
      end
    end
  
    def password_form
      @link = Link.find_by(id: params[:id])
      if @link.nil?
        render 'errors/404', status: :not_found
        return 
      end
    end

    def verificar_clave
      @link = Link.find(params[:id])
      if @link.authenticate(params[:password])
        @link.increment!(:access_count)
        LinkAccess.create(link: @link, accessed_at: Time.current, ip_address: request.remote_ip)
        redirect_to @link.url, allow_other_host: true
      else
        # Manejar contraseña incorrecta
        redirect_to password_form_link_path(@link), alert: 'Contraseña incorrecta'
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
    
      # Asegúrate de que las fechas de inicio y fin son fechas válidas o nil
      start_date = params[:start_date].presence && Date.parse(params[:start_date]).beginning_of_day
      end_date = params[:end_date].presence && Date.parse(params[:end_date]).end_of_day
    
      # Si no se proporciona start_date, usa la fecha del primer acceso
      start_date ||= @link.link_accesses.minimum(:accessed_at)&.to_date&.beginning_of_day
      # Si no se proporciona end_date, usa la fecha y hora actual
      end_date ||= Time.zone.now.end_of_day
    
      # Filtro por IP si se proporciona
      ip_address = params[:ip_address].presence
    
      # Cadena de consultas basadas en los parámetros proporcionados
      @accesses = @link.link_accesses
                        .where('accessed_at >= ?', start_date)
                        .where('accessed_at <= ?', end_date)
                        .yield_self { |query| ip_address ? query.where(ip_address: ip_address) : query }
                        .order(accessed_at: :desc)
    
      # Agrupando y contando accesos por día
      @daily_accesses = @accesses.each_with_object(Hash.new(0)) do |access, counts|
        date = access.accessed_at.to_date
        counts[date] += 1
      end
    
      # Ordenas el hash por fecha
      @daily_accesses = @daily_accesses.sort.to_h
    end
  
    def solicitar_clave
        @link = Link.find(params[:id])
    end


    private
  
    def set_link
      @link = current_user.links.find(params[:id])
    end
  
    def link_params
      params.require(:link).permit(:url, :link_type, :password, :expiration_date)
    end
      
end  