#encoding: utf-8
require 'job'

namespace :hpu do
  desc "TODO"
  task :load_capnhatdaotao => :environment do 
  	ThongKe.all.each do |tk|
  		mon = tk.ma_mon
  		as = ThongKe.where(ma_mon: mon).pluck(:tenant_id).uniq
  		tt = ThayThe.where(from_id: tk.id).pluck(:dest_id).uniq
  		if as.count > 0  or tt.count > 0	
  			if as.count > 0	
	  			tns = Tenant.find(as).map {|p| {id: p.id, khoa: p.khoa, he: p.he, nganh: p.nganh} }
	  			tk.thuoc_ctdt = tns.to_json
  			end
  			if tt.count > 0
  				tts = ThongKe.find(tt).map { |p| {id: p.id, ma_mon: p.ma_mon, ten_mon: p.ten_mon} }
  				tk.co_the_thay_the = tts.to_json
  			end
  			tk.save!
  		end
  	end
  end
  task :load_monthaythe => :environment do 
  	@client = Savon.client(wsdl: "http://10.1.0.236:8088/HPUWebService.asmx?wsdl")    
  	response = @client.call(:mon_thay_the_khoa_he_nganh)      
    res_hash = response.body.to_hash
    result = res_hash[:mon_thay_the_khoa_he_nganh_response][:mon_thay_the_khoa_he_nganh_result][:diffgram][:document_element][:mon_thay_the_khoa_he_nganh]
    result.each do |r|
    	khoa = r[:ma_khoa_hoc].to_s.strip.upcase
	    he = r[:ma_he_dao_tao].to_s.strip.upcase
	    nganh = r[:ma_nganh].to_s.strip.upcase
	    ma_mon = r[:ma_mon_hoc].to_s.strip.upcase
	    khoa2 = r[:ma_khoa_hoc2].to_s.strip.upcase
	    he2 = r[:ma_he_dao_tao2].to_s.strip.upcase
	    nganh2 = r[:ma_nganh2].to_s.strip.upcase
	    ma_mon2 = r[:ma_mon_hoc2].to_s.strip.upcase
	    tenant = Tenant.where(khoa: khoa, he: he, nganh: nganh, nam_hoc: "2013-2014", hoc_ky: 1).first
	    tenant2 = Tenant.where(khoa: khoa2, he: he2, nganh: nganh2, nam_hoc: "2013-2014", hoc_ky: 1).first
	    if tenant and tenant2	    	
	    	tk1 = tenant.thong_kes.where(ma_mon: ma_mon).first
	    	tk2 = tenant2.thong_kes.where(ma_mon: ma_mon2).first
	    	if tk1 and tk2
	    		tt = ThayThe.where(from_id: tk1.id, dest_id: tk2.id).first_or_create!
	    		puts tt.id
	    	end
	    end
    end
  end
  task :load_khoahenganh => :environment do
  	@client = Savon.client(wsdl: "http://10.1.0.236:8088/HPUWebService.asmx?wsdl")    
  	response = @client.call(:danh_sach_cac_mon_theo_khoa_he_nganh)      
    res_hash = response.body.to_hash
    result = res_hash[:danh_sach_cac_mon_theo_khoa_he_nganh_response][:danh_sach_cac_mon_theo_khoa_he_nganh_result][:diffgram][:document_element][:danh_sach_cac_mon_theo_khoa_he_nganh]
    result.each do |r|
	    khoa = r[:ma_khoa_hoc].to_s.strip.upcase
	    he = r[:ma_he_dao_tao].to_s.strip.upcase
	    nganh = r[:ma_nganh].to_s.strip.upcase
	    ma_mon = r[:ma_mon_hoc].to_s.strip.upcase
	    ten_mon = r[:ten_mon_hoc].strip
	  	tenant = Tenant.where(khoa: khoa, he: he, nganh: nganh, nam_hoc: "2013-2014", hoc_ky: 1).first_or_create!
	  	if tenant
	  		tenant.thong_kes.where(ma_mon: ma_mon, ten_mon: ten_mon).first_or_create!
	  	end
  	end
  end

  task :load_status => :environment do 
  	status = {'#FF0000' => 1, '#CCCC00' => 2, '#0033FF' => 3, '#006666' => 4, '#9900FF' => 5}
    client = Savon.client(wsdl: "http://10.1.0.236:8088/HPUWebService.asmx?wsdl")
  	Tenant.all.each do |tenant|
  		c1 = (tenant.thong_kes.where('level is not null').count || 0)
  		c2 = (count(client, tenant.khoa, tenant.he, tenant.nganh, status) || 0)
  		if c1 < c2  		
	  		res = process(client, tenant.khoa, tenant.he, tenant.nganh, status)  	
	  		if res and res.count > 0
		  		tres = transform(res)	
		  		if tres.count > 0
		  			tres.each do |r|
		  				tk = tenant.thong_kes.where(ma_mon: r[:key][1].upcase).first	  				
		  				tk.level = r[:key][0].to_i
		  				tk.tu_chon = (r[:value][0]["tuchon"].to_i > 0)
		  				tk.so_tim = r[:so_tim].count
		  				tk.so_do = r[:so_do].count
		  				tk.so_vang = r[:so_vang].count
		  				tk.so_danghoc = r[:so_danghoc].count
		  				tk.so_daqua = r[:so_daqua].count
		  				tk.so_sv = r[:count].to_i
		  				tk.sv = { :so_tim => r[:so_tim],
		  					:so_do => r[:so_do],
		  					:so_vang => r[:so_vang],
		  					:so_danghoc => r[:so_danghoc],
		  					:so_daqua => r[:so_daqua]
		  					}
		  				.to_json
		  				tk.save!
		  			end
		  		end
		  	end
		end
  	end
  end
  def transform(res)
    res.group_by {|t| [t["group"], t["mamon"]]}.map {|k,v| {:key => k, :count => v.count, :so_tim => v.select {|t| t["status"] == 5}, :so_vang => v.select {|t| t["status"] == 2},
      :so_do => v.select {|t| t["status"] == 1}, :so_danghoc => v.select {|t| t["status"] == 3}, :so_daqua => v.select {|t| t["status"] == 4}, :value => v
      }}
  end
  def load_sv(client, ma_khoa_hoc, ma_he_dao_tao, ma_nganh, status)    
    response = client.call(:sinh_vien_khoa_he_nganh) do 
      message(makhoahoc: ma_khoa_hoc, mahedaotao: ma_he_dao_tao, manganh: ma_nganh)
    end
    res_hash = response.body.to_hash
    result = res_hash[:sinh_vien_khoa_he_nganh_response][:sinh_vien_khoa_he_nganh_result][:diffgram][:document_element]
    if (result ) then 
		temp = result[:sinh_vien_khoa_he_nganh];
		if (temp.is_a?(Hash)) then 
			result = Array.new
			result.push(temp);
		else (temp.is_a?(Array))
			result = temp;
		end		
	end
    if result then  return result.map {|k| k[:ma_sinh_vien] and k[:ma_sinh_vien].strip}
    else return [] end
  end
  def count(client, ma_khoa_hoc, ma_he_dao_tao, ma_nganh, status)
    #keys = ["name","group","color","ma_sinh_vien","mamon","status"]
    keys = []
    svs = load_sv(client, ma_khoa_hoc, ma_he_dao_tao, ma_nganh, status)
    return nil if svs.count == 0   
    sv = svs[0]    
    tmp = RestClient.get "http://localhost:8181/127.0.0.1/#{sv}"
    result = JSON.parse(tmp)["nodes"]  
    #return 0 if result.nil
	return result.count    
  end
  def process(client, ma_khoa_hoc, ma_he_dao_tao, ma_nganh, status)
    #keys = ["name","group","color","ma_sinh_vien","mamon","status"]
    keys = []
    svs = load_sv(client, ma_khoa_hoc, ma_he_dao_tao, ma_nganh, status)
    return nil if svs.count == 0
    @result = []
    svs.each do |sv|
      tmp = RestClient.get "http://localhost:8181/127.0.0.1/#{sv}"
      @result += JSON.parse(tmp)["nodes"]  
      @result.map {|t| t["ma_sinh_vien"] = sv ; t["status"] = status[t["color"]];t}            
    end        
    #x = @result.map {|t| t.reject { |key,_| !keys.include? key }  }
    #transform(@result)
    @result
  end
end