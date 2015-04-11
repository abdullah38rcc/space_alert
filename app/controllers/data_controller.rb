class DataController < ApplicationController
  respond_to :html, :json, :xml
  layout false, only: [:bexrb, :news]
  layout "mobile", only: [:mobile_news]

  def index
  end

  def bexrb
  	@bexrbs = Bexrb.order("(IFNULL(maxi_flux_change_prob,0) + IFNULL(swift_flux_change_prob,0) + IFNULL(fermi_flux_change_prob,0)) desc")
  	respond_with(@bexrbs)
  end

  def news
  	@news = News.where(state: "Active").order("created_at desc")
  	respond_with(@news)
  end

  def mobile_news
  	@news = News.where(state: "Active").order("pub_date desc")
  end
end
