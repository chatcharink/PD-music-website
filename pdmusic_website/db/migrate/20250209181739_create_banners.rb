class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.text :banner_image
      t.string :menu_tag, limit: 150
      t.column :status, "ENUM('active', 'inactive', 'pre_delete', 'deleted') DEFAULT 'active'"
      t.timestamps
    end
  end
end
