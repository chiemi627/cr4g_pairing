class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :account
      t.string :name
      t.string :googlesheet
      t.timestamps

    end
  end
end
