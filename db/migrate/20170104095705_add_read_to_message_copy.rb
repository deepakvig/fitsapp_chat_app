class AddReadToMessageCopy < ActiveRecord::Migration[5.0]
  def change
    add_column :message_copies, :read, :boolean, default: false
  end
end
