class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :title_content, limit: 250
      t.string :title_url, limit: 250
      t.text :url
      t.text :image
      t.text :content
      t.integer :content_format, limit: 3
      t.string :menu, limit: 150
      t.bigint :categories_id, limit: 20
      t.bigint :is_child_of, limit: 20
      t.column :status, "ENUM('active', 'inactive', 'pre_delete', 'deleted') DEFAULT 'active'"
      t.timestamps
    end
  end
end
