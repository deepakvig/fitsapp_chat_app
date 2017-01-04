class CreateMessageCopies < ActiveRecord::Migration[5.0]
  def change
    create_table :message_copies do |t|
      t.integer :recipient_id
      t.integer :message_id

      t.timestamps
    end
  end
end
