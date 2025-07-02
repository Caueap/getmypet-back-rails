class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :zipCode
      t.string :avatar
      t.string :role

      t.timestamps
    end
  end
end
