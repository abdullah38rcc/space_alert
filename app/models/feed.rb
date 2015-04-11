require 'net/http'

class Feed < ActiveRecord::Base
	validates :url, presence: true

	def read
		case self.parser_class
		when "RSS"
			parse_rss
		when "bexrbmonitor"
			parse_bexrb
		when "astronomerstelegram"
			parse_astronomerstelegram
		end
		
	end

private 
	def parse_rss
		@feeds = Feedjira::Feed.fetch_and_parse(self.url)

	    begin
	      @feeds.entries.each { |entry| 
	          news = News.find_or_initialize_by(source: self.id, code: entry.id)
	          news.title = entry.title
	          news.desc = entry.content
	          news.link = entry.links.first
	          news.pub_date = entry.published
	          news.image = "" 
	          news.state = "Active"
	          news.category = "News"
	          news.source = self.id
	          news.save
	      }
	    rescue
	    else
	      self.last_connected_at = Time.now
	      self.save
	    end
	end

	def parse_bexrb
		begin
			opt_url = self.url
		    hdrs = {"User-Agent"=>"Mozilla/5.0 (Windows NT 6.3; Win64; x64)"}
		    hdrs["Accept-Charset"] = "utf-8"
		    hdrs["Accept"] = "text/html"
		    bexrb_html = ""

		    open(opt_url, hdrs).each {|s| bexrb_html << s.to_s}

		    doc = Nokogiri::HTML(bexrb_html)
		    bexrbs = doc.css("#table_wrapper tbody tr")

		    bexrbs.each { |bexrb| 
		      begin
		        bexrb_td = bexrb.css("td")
		        _bexrb = Bexrb.find_or_initialize_by(name: bexrb_td[0].content)
    				# bexrb.name = bexrb_td[0].content
    				_bexrb.url = bexrb_td[0].css("a").first["href"]
    				_bexrb.ra = bexrb_td[1].content 
    				_bexrb.dec = bexrb_td[2].content 
    				_bexrb.orbit_period = bexrb_td[3].content 
    				_bexrb.maxi_prob_color = bexrb_td[4].css("span").count > 0 ? prob_color(bexrb_td[4].css("span").first["style"]) : ""
    				_bexrb.maxi_flux_change_prob = bexrb_td[4].content.to_f * (_bexrb.maxi_prob_color == "dec" ? -1 : 1)
    				_bexrb.maxi_flux_change_prob = nil if _bexrb.maxi_flux_change_prob == 0
    				_bexrb.maxi_average_flux = bexrb_td[5].content 
    				_bexrb.maxi_data = bexrb_td[6].content 
    				_bexrb.maxi_url = bexrb_td[6].css("a").count > 0 ? bexrb_td[6].css("a").first["href"] : "" 

    				_bexrb.swift_prob_color = bexrb_td[7].css("span").count > 0 ? prob_color(bexrb_td[7].css("span").first["style"]) : ""
    				_bexrb.swift_flux_change_prob = bexrb_td[7].content.to_f * (_bexrb.swift_prob_color == "dec" ? -1 : 1) 
    				_bexrb.swift_flux_change_prob = nil if _bexrb.swift_flux_change_prob == 0
    				_bexrb.swift_average_flux = bexrb_td[8].content 
    				_bexrb.swift_data = bexrb_td[9].content 
    				_bexrb.swift_url = bexrb_td[9].css("a").count > 0 ? bexrb_td[9].css("a").first["href"] : "" 

    				_bexrb.fermi_prob_color = bexrb_td[10].css("span").count > 0 ? prob_color(bexrb_td[10].css("span").first["style"]) : ""
    				_bexrb.fermi_flux_change_prob = bexrb_td[10].content.to_f * (_bexrb.fermi_prob_color == "dec" ? -1 : 1) 
    				_bexrb.fermi_flux_change_prob = nil if _bexrb.fermi_flux_change_prob == 0
    				_bexrb.fermi_average_flux = bexrb_td[11].content 
    				_bexrb.fermi_data = bexrb_td[12].content 
    				_bexrb.fermi_url = bexrb_td[12].css("a").count > 0 ? bexrb_td[12].css("a").first["href"] : "" 
    				_bexrb.combined_plot = bexrb_td[13].content
    				if _bexrb.updated_at < 1.day.ago
    				  days_html = ""
    				  open('http://integral.esac.esa.int/bexrbmonitor/' + bexrb_td[13].css("a").first["href"], hdrs).each {|s| days_html << s.to_s}
    				  _bexrb.plot_days = days_html.scan(/Weekly analysis on last (.*) days data of/)[0][0]
    				end 
    				_bexrb.save
	      		puts "Saved: #{_bexrb.name}"
		      rescue Exception => e
		        puts "Error : #{e.message} BeXRB = #{_bexrb.inspect}"
		      end
		  	}
    rescue
		else
			self.last_connected_at = Time.now
			self.save
	  end
	end

	def parse_astronomerstelegram
    begin
      
    opt_url = self.url

    uri = URI(opt_url)
    form_data = self.post_data.split("\r\n").map{ |x| x.split(":") }
    res = Net::HTTP.post_form(uri, form_data)

      doc = Nokogiri::HTML(res.body)
      doc.css("#center table tr[valign='top']").each { |item|
        item_td = item.css('td')
        news = News.find_or_initialize_by(source: self.id, code: item_td[0].text)
        news.title = item_td[1].text
        news.desc = item_td[2].text
        news.link = item_td[1].css('a').first['href']
        news.pub_date = item_td[2].css('em').text
        news.image = "" 
        news.state = "Active"
        news.category = "News"
        news.source = self.id
        news.save
      }
    rescue Exception => e
    else
      self.last_connected_at = Time.now
      self.save
    end
	end

	def prob_color(value)
		case value
		when "color:yellow"
			"inc"
		when "color:red"
			"dec"
		else
			"no-data"
		end
	end
end
