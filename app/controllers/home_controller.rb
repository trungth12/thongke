class HomeController < ApplicationController
  def index
  	khoa = params[:khoa].try(:strip) || 18
  	he = params[:he].try(:strip) || 12
  	nganh = params[:nganh].try(:strip) || 103
  	@tenant = Tenant.where(khoa: khoa, he: he, nganh: nganh).first
  	if @tenant
  		render json: @tenant, root: false
  	else
  		render json: nil
  	end
  	puts @tenant
  end
end
