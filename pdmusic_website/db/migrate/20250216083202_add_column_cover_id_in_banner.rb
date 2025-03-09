class AddColumnCoverIdInBanner < ActiveRecord::Migration[7.0]
  def change
    add_column :banners, :cover_id, :bigint, limit: 20
  end
end
