require "open-uri"

class BexrbsController < ApplicationController
  before_action :set_bexrb, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    opt_url = "http://integral.esac.esa.int/bexrbmonitor/webpage_oneplot.php"
    hdrs = {"User-Agent"=>"Mozilla/5.0 (Windows NT 6.3; Win64; x64)"}
    hdrs["Accept-Charset"] = "utf-8"
    hdrs["Accept"] = "text/html"
    bexrb_html = ""

    open(opt_url, hdrs).each {|s| bexrb_html << s.to_s}

    doc = Nokogiri::HTML(bexrb_html)
    bexrbs = doc.css("#table_wrapper tbody tr")

    bexrbs.each { |bexrb| 
      #begin
        bexrb_td = bexrb.css("td")
        _bexrb = Bexrb.find_or_initialize_by(name: bexrb_td[0].content)
          # bexrb.name = bexrb_td[0].content
          _bexrb.url = bexrb_td[0].css("a").first["href"]
          _bexrb.ra = bexrb_td[1].content 
          _bexrb.dec = bexrb_td[2].content 
          _bexrb.orbit_period = bexrb_td[3].content 
          _bexrb.maxi_flux_change_prob = bexrb_td[4].content 
          _bexrb.maxi_average_flux = bexrb_td[5].content 
          _bexrb.maxi_data = bexrb_td[6].content 
          _bexrb.maxi_url = bexrb_td[6].css("a").count > 0 ? bexrb_td[6].css("a").first["href"] : "" 
          _bexrb.swift_flux_change_prob = bexrb_td[7].content 
          _bexrb.swift_average_flux = bexrb_td[8].content 
          _bexrb.swift_data = bexrb_td[9].content 
          _bexrb.swift_url = bexrb_td[9].css("a").count > 0 ? bexrb_td[9].css("a").first["href"] : "" 
          _bexrb.fermi_flux_change_prob = bexrb_td[10].content 
          _bexrb.fermi_average_flux = bexrb_td[11].content 
          _bexrb.fermi_data = bexrb_td[12].content 
          _bexrb.fermi_url = bexrb_td[12].css("a").count > 0 ? bexrb_td[12].css("a").first["href"] : "" 
          _bexrb.combined_plot = bexrb_td[13].content
          days_html = ""
          open('http://integral.esac.esa.int/bexrbmonitor/' + bexrb_td[13].css("a").first["href"], hdrs).each {|s| days_html << s.to_s}
          _bexrb.plot_days = days_html.scan(/Weekly analysis on last (.*) days data of/)[0][0]
          _bexrb.save
      puts "Saved: #{_bexrb.name}"
      #rescue Exception => e
      #  puts "Error : #{e.message} BeXRB = #{_bexrb.inspect}"
      #end
  }

    @bexrbs = Bexrb.all
    respond_with(@bexrbs)
  end

  def show
    respond_with(@bexrb)
  end

  def new
    @bexrb = Bexrb.new
    respond_with(@bexrb)
  end

  def edit
  end

  def create
    @bexrb = Bexrb.new(bexrb_params)
    @bexrb.save
    respond_with(@bexrb)
  end

  def update
    @bexrb.update(bexrb_params)
    respond_with(@bexrb)
  end

  def destroy
    @bexrb.destroy
    respond_with(@bexrb)
  end

  private
    def set_bexrb
      @bexrb = Bexrb.find(params[:id])
    end

    def bexrb_params
      params.require(:bexrb).permit(:name, :ra, :dec, :orbit_period, :maxi_flux_change_prob, :maxi_data, :swift_flux_change_prob, :swift_average_flux, :swift_data, :fermi_flux_change_prob, :fermi_average_flux, :fermi_data, :combined_plot, :plot_days)
    end
end
