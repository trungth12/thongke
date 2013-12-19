class ApplicationController < ActionController::Base
  protect_from_forgery
  def show
  	khoa = params[:khoa].try(:strip)
  	he = params[:he].try(:strip)
  	nganh = params[:nganh].try(:strip)
  	@tenant = Tenant.where(khoa: khoa, he: he, nganh: nganh).first
  	if @tenant
  		render json: @tenant, root: false
  	else
  		render json: nil
  	end
  end
end
