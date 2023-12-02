class RegistrationsController < Devise::RegistrationsController
    def destroy
      # Eliminar links relacionados a esta cuenta
      resource.links.each do |link|
        link.link_accesses.destroy_all
      end
      resource.links.destroy_all
      super
    end
end