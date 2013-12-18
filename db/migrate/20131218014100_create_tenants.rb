class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :khoa
      t.string :he
      t.string :nganh
      t.integer :hoc_ky
      t.string :nam_hoc

      t.timestamps
    end
  end
end
