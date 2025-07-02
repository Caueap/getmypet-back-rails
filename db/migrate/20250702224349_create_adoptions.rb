class CreateAdoptions < ActiveRecord::Migration[8.0]
  def change
    create_table :adoptions do |t|
      t.references :pet, null: false, foreign_key: true
      t.references :applicant, null: false, foreign_key: {to_table: :users}
      t.references :owner, null: false, foreign_key: {to_table: :users}
      t.string :status
      t.text :message
      t.text :owner_notes
      t.datetime :application_date
      t.datetime :response_date
      t.datetime :completion_date

      t.timestamps
    end
  end
end
