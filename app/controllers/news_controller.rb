require "open-uri"

class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def bexrbs
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
        _bexrb = Bexrb.find_or_initialize_by(name: bexrb[0].content)
          # bexrb.name = bexrb[0].content
          _bexrb.url = bexrb[0].css("a").first["href"]
          _bexrb.ra = bexrb[1].content 
          _bexrb.dec = bexrb[2].content 
          _bexrb.orbit_period = bexrb[3].content 
          _bexrb.maxi_flux_change_prob = bexrb[4].content 
          _bexrb.maxi_data = bexrb[5].content 
          _bexrb.maxi_url = bexrb[5].css("a").count > 0 ? bexrb[5].css("a").first["href"] : "" 
          _bexrb.swift_flux_change_prob = bexrb[6].content 
          _bexrb.swift_average_flux = bexrb[7].content 
          _bexrb.swift_data = bexrb[8].content 
          _bexrb.swift_url = bexrb[8].css("a").count > 0 ? bexrb[8].css("a").first["href"] : "" 
          _bexrb.fermi_flux_change_prob = bexrb[9].content 
          _bexrb.fermi_average_flux = bexrb[10].content 
          _bexrb.fermi_data = bexrb[11].content 
          _bexrb.combined_plot = bexrb[12].content 
          _bexrb.plot_days = ""
      _bexrb.save
      puts "Saved: #{_bexrb.name}"
      #rescue Exception => e
      #  puts "Error : #{e.message} BeXRB = #{_bexrb.inspect}"
      #end
  }

    @bexrbs = News.where(state: "Active", category: "BeXRB")
  end

  def index
    @news = News.where(state: "Active", category: "News")
    respond_with(@news)
  end

  def show
    respond_with(@news)
  end

  def new
    @news = News.new
    respond_with(@news)
  end

  def edit
  end

  def create
    @news = News.new(news_params)
    @news.save
    respond_with(@news)
  end

  def update
    @news.update(news_params)
    respond_with(@news)
  end

  def destroy
    @news.destroy
    respond_with(@news)
  end

  private
    def set_news
      @news = News.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title, :desc, :link, :pub_date, :image, :code)
    end
end
