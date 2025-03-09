class CreateEmbeds < ActiveRecord::Migration[7.0]
  def change
    create_table :embeds do |t|
      t.text :url
      t.timestamps
    end
  end
end
