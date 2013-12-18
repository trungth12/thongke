namespace :hpu do
  desc "TODO"
  
  task :load_khoahenganh => :environment do
  	tenant = Tenant.new
  	tenant.nam_hoc = "2013-2014"
  	tenant.hoc_ky = 1
  	# pending
  end
end