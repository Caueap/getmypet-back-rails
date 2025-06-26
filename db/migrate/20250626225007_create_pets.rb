class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.string :breed
      t.string :size
      t.integer :age
      t.string :gender
      t.string :description
      t.string :status
      t.boolean :isNeutered
      t.string :location

      t.timestamps
    end
  end
end
