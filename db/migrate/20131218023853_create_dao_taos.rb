class CreateDaoTaos < ActiveRecord::Migration
  def change
    create_table :dao_taos do |t|
      t.integer :thongke_id
      t.integer :tenant_id

      t.timestamps
    end
  end
end
