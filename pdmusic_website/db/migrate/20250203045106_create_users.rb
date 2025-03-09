class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, limit: 250
      t.string :salt_password, limit: 250
      t.string :password, limit: 250 
      t.string :firstname, limit: 250
      t.string :lastname, limit: 250
      t.column :status, "ENUM('active', 'inactive', 'deleted') DEFAULT 'active'"
      t.integer :role, limit: 2
      t.string :email, limit: 250
      t.string :phone_number, limit: 20
      t.text :profile_pic
      t.timestamps
    end
  end
end
