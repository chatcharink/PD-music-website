class CreateTabs < ActiveRecord::Migration[7.0]
  def change
    create_table :tabs do |t|
      t.string :tab_name, limit: 150
      t.text :description
      t.column :status, "ENUM('active', 'deleted') DEFAULT 'active'"
      t.timestamps
    end
  end
end
