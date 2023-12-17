class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :student_index
      t.string :name
      t.string :surname
      t.string :email


      t.timestamps
    end
  end
end
