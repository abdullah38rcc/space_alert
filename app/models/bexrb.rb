class Bexrb < ActiveRecord::Base
	before_save :check_changes

	def check_changes
		if self.new_record? and self.plot_days.to_f < 5

			news = News.new(source: "SpaceAlert", code: self.name)
			news.title = "New Records in BeXRB Table Name: #{self.name}"
			news.desc = "ra: #{self.ra}, dec: #{self.dec}, orbit_period: #{ra.orbit_period}"
			news.pub_date = Time.now
			news.image = "" 
			news.state = "Active"
			news.category = "News"
			if news.save
				news.link = Rails.application.routes.url_helpers.news_url(id: news.id, host: 'spacealert.ipos.com.tr')
				news.save
			end
		else
			threshold = 30
			create_news = false
			self.changes.each { |k,v|
				old_value, new_value = v
				if new_value == nil and old_value.to_f.abs >= threshold
					create_news = true
					break
				elsif old_value == nil and new_value.to_f.abs >= threshold
					create_news = true
					break
				elsif ((old_value.to_f - new_value.to_f).abs >= threshold) or ((new_value.to_f - old_value.to_f).abs >= threshold)
					create_news = true
					break
				end
			}

			if create_news 
				change_text = ""
				self.changes.each { |k,v| 
					old_value, new_value = v
					change_text += I18n.t("bexrf.#{k}", default: k) + " changed from #{old_value.to_s} to #{new_value.to_s}. \n" 
				}
				news = News.new(source: "SpaceAlert", code: self.name)
				news.title = "Changes In #{self.name}"
				news.desc = change_text
				news.pub_date = Time.now
				news.image = "" 
				news.state = "Active"
				news.category = "News"
				if news.save
					news.link = Rails.application.routes.url_helpers.news_url(id: news.id, host: 'spacealert.ipos.com.tr')
					news.save
				end
		    end
		end

	    return true
	end
end
