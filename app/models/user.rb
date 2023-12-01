class User < ApplicationRecord
  # Incluyendo módulos predeterminados de Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relación con Link
  has_many :links, dependent: :destroy

  # Validaciones
  validates :username, presence: true, uniqueness: true

  # ... cualquier otra lógica de modelo que necesites
end
