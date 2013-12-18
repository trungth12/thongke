class AddTenantIdToThongKe < ActiveRecord::Migration
  def change
    add_column :thong_kes, :tenant_id, :integer
  end
end
