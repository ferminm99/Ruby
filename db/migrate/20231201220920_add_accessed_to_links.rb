class AddAccessedToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :accessed, :boolean, null: false, default: false
  end
end
