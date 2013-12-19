class AddDaotaoIdAndThaytheIdToThongke < ActiveRecord::Migration
  def change
    add_column :thong_kes, :dao_tao_id, :integer
    add_column :thong_kes, :thay_the_id, :integer
  end
end
