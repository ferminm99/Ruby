class LinkAccess < ApplicationRecord
  belongs_to :link
  validates :link_id, :ip_address, presence: true
  validates :ip_address, presence: true
end
