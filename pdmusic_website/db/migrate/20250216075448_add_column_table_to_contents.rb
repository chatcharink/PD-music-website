class AddColumnTableToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :additional_content_id, :bigint, limit: 20
    add_column :contents, :table, :json
  end
end
