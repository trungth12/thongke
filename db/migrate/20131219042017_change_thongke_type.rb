class ChangeThongkeType < ActiveRecord::Migration
  def change
  	change_column :thong_kes, :thuoc_ctdt, :text, :limit => nil
  	remove_column :thong_kes, :dao_tao_id
  	remove_column :thong_kes, :thay_the_id
  end
end
