class ChangeLinkTypeToIntegerInLinks < ActiveRecord::Migration[7.1]
  def up
    add_column :links, :link_type_temp, :integer

    # Asigna los valores enteros correspondientes a la nueva columna
    Link.reset_column_information
    Link.find_each do |link|
      link.update(link_type_temp: Link.link_types[link.link_type])
    end

    remove_column :links, :link_type
    rename_column :links, :link_type_temp, :link_type
  end

  def down
    # Lógica para revertir la migración si es necesario
    rename_column :links, :link_type, :link_type_temp
    add_column :links, :link_type, :string

    Link.reset_column_information
    Link.find_each do |link|
      link.update(link_type: Link.link_types.key(link.link_type_temp))
    end

    remove_column :links, :link_type_temp
  end
end
