class Tenant < ActiveRecord::Base
  attr_accessible :he, :hoc_ky, :khoa, :nam_hoc, :nganh

  has_many :thong_kes, :dependent => :destroy
end
