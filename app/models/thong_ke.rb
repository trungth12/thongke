class ThongKe < ActiveRecord::Base
  #attr_accessible :co_the_thay_the, :level, :ma_mon, :so_danghoc, :so_daqua, :so_do, :so_tim, :so_vang, :ten_mon, :thuoc_ctdt, :tu_chon

  belongs_to :tenant

  has_many :froms, :class_name => "ThayThe", :foreign_key => "from_id", inverse_of: :from  
  has_many :dests, :class_name => "ThayThe", :foreign_key => "dest_id", inverse_of: :dest  
end
