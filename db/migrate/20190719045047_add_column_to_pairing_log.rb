class AddColumnToPairingLog < ActiveRecord::Migration[5.1]
  def change
    add_column :pairing_logs, :event, :string
  end
end
