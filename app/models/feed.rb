class Feed < ActiveRecord::Base
	def read
		@feeds = Feedjira::Feed.fetch_and_parse(self.url)

	    begin
	      @feeds.entries.each { |entry| 
	          news = News.find_or_initialize_by(code: entry.id)
	          news.title = entry.title
	          news.desc = entry.content
	          news.link = entry.links.first
	          news.pub_date = entry.published
	          news.image = "" 
	          news.state = "Active"
	          news.category = "News"
	          news.save
	      }
	    rescue
	    else
	      self.last_connected_at = Time.now
	      self.save
	    end
	end
end
