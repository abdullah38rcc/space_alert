require 'open-uri'

class VisitorsController < ApplicationController
	def index
		@bexrbs = Bexrb.where("maxi_flux_change_prob is not null or swift_flux_change_prob is not null or fermi_flux_change_prob is not null").order("(IFNULL(maxi_flux_change_prob,0) + IFNULL(swift_flux_change_prob,0) + IFNULL(fermi_flux_change_prob,0)) desc")

		@latest_news = News.where(state: "Active").order("pub_date desc").limit(15)

		begin
			@picture_of_day = JSON.load(open("https://api.data.gov/nasa/planetary/apod?concept_tags=True&api_key=J4fQWQ9ht9Uc6u4uLtiE9HgmqXvrmy2XzyS58Nqs"))
		rescue Exception => e
			@picture_of_day = nil
		end
	end
end
