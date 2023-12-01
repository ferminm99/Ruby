class AddFieldsToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :slug, :string
    add_column :links, :link_type, :string
    add_column :links, :password_digest, :string
    add_column :links, :expiration_date, :datetime
    add_column :links, :access_count, :integer
  end
end
