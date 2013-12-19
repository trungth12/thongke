class TenantSerializer < ActiveModel::Serializer
  attributes :khoa, :he, :nganh, :hoc_ky, :nam_hoc
  has_many :thong_kes

  def thong_kes
    object.thong_kes.where("level is not null")
  end
end
