# db/migrate/xxxx_create_messages.rb
class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.string :title
      t.text :body
      t.boolean :sent, default: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
