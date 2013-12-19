class AddSvToThongKe < ActiveRecord::Migration
  def change
    add_column :thong_kes, :sv, :text
  end
end
