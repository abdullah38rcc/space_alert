class VisitorsController < ApplicationController
	def index
		@bexrbs = Bexrb.where("maxi_flux_change_prob is not null or swift_flux_change_prob is not null or fermi_flux_change_prob is not null").order("(IFNULL(maxi_flux_change_prob,0) + IFNULL(swift_flux_change_prob,0) + IFNULL(fermi_flux_change_prob,0)) desc")

		@latest_news = News.where(state: "Active").order("pub_date desc").limit(15)
	end
end
