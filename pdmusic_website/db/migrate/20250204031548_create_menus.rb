class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string :menu_name, limit: 150
      t.string :menu_tag, limit: 150
      t.text :icon
      t.column :status, "ENUM('active', 'inactive', 'pre_delete', 'deleted') DEFAULT 'active'"
      t.timestamps
    end
  end
end
