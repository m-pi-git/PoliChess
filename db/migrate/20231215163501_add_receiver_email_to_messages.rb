class AddReceiverEmailToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :receiver_email, :string
  end
end
