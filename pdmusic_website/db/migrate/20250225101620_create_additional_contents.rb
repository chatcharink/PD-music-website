class CreateAdditionalContents < ActiveRecord::Migration[7.0]
  def change
    create_table :additional_contents do |t|
      t.string :title, limit: 250
      t.text :url
      t.text :image
      t.text :html_content
      t.string :menu, limit: 100
      t.bigint :gallery_id, limit: 20
      t.column :status, "ENUM('active', 'inactive', 'pre_delete', 'deleted') DEFAULT 'active'"
      t.timestamps
    end
  end
end
