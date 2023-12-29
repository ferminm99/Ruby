class AddFieldsToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :slug, :string, null: false
    add_index :links, :slug, unique: true
    add_column :links, :link_type, :string, null: false
    add_column :links, :password_digest, :string
    add_column :links, :expiration_date, :datetime
    add_column :links, :access_count, :integer, default: 0
  end
end
