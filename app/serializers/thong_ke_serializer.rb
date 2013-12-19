class ThongKeSerializer < ActiveModel::Serializer
  attributes :ma_mon, :ten_mon, :level, :so_tim, :so_vang, :so_do, :so_danghoc, :so_daqua, :ctdt, :thaythe, :sv_tim, :sv_vang, :sv_do, :sv_danghoc, :sv_daqua

  def ctdt
  	return [] if object.thuoc_ctdt.nil?
  	JSON.parse(object.thuoc_ctdt)
  end

  def thaythe
  	return [] if object.co_the_thay_the.nil?
  	JSON.parse(object.co_the_thay_the)
  end

  def sv_tim
  	return [] if object.so_tim == 0 or object.so_tim.nil?
  	tmp = JSON.parse(object.sv)
  	return {:sv_tim => tmp["so_tim"]}
  end

  def sv_vang
  	return [] if object.so_vang == 0 or object.so_vang.nil?
  	tmp = JSON.parse(object.sv)
  	return {:sv_vang => tmp["so_vang"]}
  end

  def sv_do
  	return [] if object.so_do == 0 or object.so_do.nil?
  	tmp = JSON.parse(object.sv)
  	return {:sv_do => tmp["so_do"]}
  end

  def sv_danghoc
  	return [] if object.so_danghoc == 0 or object.so_danghoc.nil?
  	tmp = JSON.parse(object.sv)
  	return {:sv_danghoc => tmp["so_danghoc"]}
  end

  def sv_daqua
  	return [] if object.so_daqua == 0 or object.so_daqua.nil?
  	tmp = JSON.parse(object.sv)
  	return {:sv_daqua => tmp["so_daqua"]}
  end
end
