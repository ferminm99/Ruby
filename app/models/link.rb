class Link < ApplicationRecord
  belongs_to :user
  before_validation :generate_slug, on: :create
  enum link_type: { regular: 0, temporal: 1, private_link: 2, ephemeral: 3 }

  # Validaciones
  validates :url, presence: true
  validates :slug, uniqueness: true, presence: true
  validates :password_digest, presence: true, if: :private_link?
  validates :expiration_date, presence: true, if: :temporal?

  private
  # Generación del slug
  def generate_slug
    if self.slug.blank?
      self.slug = loop do
        random_slug = SecureRandom.alphanumeric(6)
        break random_slug unless Link.exists?(slug: random_slug)
      end
    end
  end

  # Verificar si el link está expirado
  def expired?
    temporal? && expiration_date < Time.current
  end

  public
  # Verificar si el link es accesible (no expirado y no usado si es efímero)
  def accessible?
    !expired? && (!ephemeral? || (ephemeral? && access_count.zero?))
  end

  # Lógica para incrementar el contador de accesos (para links efímeros)
  def increment_access_count
    increment!(:access_count)
  end
end

