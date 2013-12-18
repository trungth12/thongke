class CreateThongKes < ActiveRecord::Migration
  def change
    create_table :thong_kes do |t|
      t.string :ma_mon
      t.string :ten_mon
      t.integer :level
      t.boolean :tu_chon
      t.integer :so_tim
      t.integer :so_vang
      t.integer :so_do
      t.integer :so_danghoc
      t.integer :so_daqua
      t.string :thuoc_ctdt
      t.text :co_the_thay_the

      t.timestamps
    end
  end
end
