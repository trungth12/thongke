class ThayThe < ActiveRecord::Base
  #attr_accessible :dest_id, :from_id

  belongs_to :from, inverse_of: :froms
  belongs_to :dest, inverse_of: :dests
end
