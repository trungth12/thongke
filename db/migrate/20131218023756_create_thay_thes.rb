class CreateThayThes < ActiveRecord::Migration
  def change
    create_table :thay_thes do |t|
      t.integer :from_id
      t.integer :dest_id

      t.timestamps
    end
  end
end
