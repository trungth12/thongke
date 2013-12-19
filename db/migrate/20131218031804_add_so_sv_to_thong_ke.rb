class AddSoSvToThongKe < ActiveRecord::Migration
  def change
    add_column :thong_kes, :so_sv, :integer
  end
end
