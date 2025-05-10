class AddColumnHeaderFooterToMenu < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :header, :integer, limit: 2
    add_column :menus, :footer, :integer, limit: 2
  end
end
