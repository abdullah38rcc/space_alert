require "open-uri"

namespace :feed do
  desc "TODO"
  task read: :environment do
  	Feed.where(state: "Active").each { |feed| 
  		feed.read
  	}

  	opt_url = "http://integral.esac.esa.int/bexrbmonitor/webpage_oneplot.php"
    hdrs = {"User-Agent"=>"Mozilla/5.0 (Windows NT 6.3; Win64; x64)"}
    hdrs["Accept-Charset"] = "utf-8"
    hdrs["Accept"] = "text/html"
    bexrb_html = ""

    open(opt_url, hdrs).each {|s| bexrb_html << s.to_s}

    doc = Nokogiri::HTML(bexrb_html)
    bexrbs = doc.css("#table_wrapper tbody tr")

    bexrbs.each { |bexrb| 
    	begin
	    	_bexrb = Bexrb.find_or_initialize_by(name: bexrb[0].content)
	      	# bexrb.name = bexrb[0].content
	      	_bexrb.url = bexrb[0].css("a").first["href"]
	      	_bexrb.ra = bexrb[1].content rescue ""
	      	_bexrb.dec = bexrb[2].content rescue ""
	      	_bexrb.orbit_period = bexrb[3].content rescue ""
	      	_bexrb.maxi_flux_change_prob = bexrb[4].content rescue ""
	      	_bexrb.maxi_data = bexrb[5].content rescue ""
	      	_bexrb.maxi_url = bexrb[5].css("a").count > 0 ? bexrb[5].css("a").first["href"] : "" 
	      	_bexrb.swift_flux_change_prob = bexrb[6].content rescue ""
			_bexrb.swift_average_flux = bexrb[7].content rescue ""
			_bexrb.swift_data = bexrb[8].content rescue ""
			_bexrb.swift_url = bexrb[8].css("a").count > 0 ? bexrb[8].css("a").first["href"] : "" 
			_bexrb.fermi_flux_change_prob = bexrb[9].content rescue ""
			_bexrb.fermi_average_flux = bexrb[10].content rescue ""
			_bexrb.fermi_data = bexrb[11].content rescue ""
			_bexrb.combined_plot = bexrb[12].content rescue ""
			_bexrb.plot_days = ""
			_bexrb.save
			puts "Saved: #{_bexrb.name}"
    	rescue Exception => e
    		puts "Error : #{e.message} BeXRB = #{_bexrb.inspect}"
    	end
  }
  end

end
