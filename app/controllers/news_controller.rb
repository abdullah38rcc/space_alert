require "open-uri"

class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:mobile_feeds, :show]

  respond_to :html

  def mobile_feeds
    data = []
    News.where(state: "Active").order("pub_date desc").each { |news| 
        data << {title: HTML::FullSanitizer.new.sanitize(news.title), description: HTML::FullSanitizer.new.sanitize(news.desc), link: news.link, pub_date: news.pub_date, image: news.image }
    }

    render xml: data.to_xml(:root => 'items')
  end

  def mobile_space_alerts
    data = []
    News.where(state: "Active").where(source: "SpaceAlert").order("pub_date desc").each { |news| 
        data << {title: HTML::FullSanitizer.new.sanitize(news.title), description: HTML::FullSanitizer.new.sanitize(news.desc), link: news.link, pub_date: news.pub_date, image: news.image }
    }

    render xml: data.to_xml(:root => 'items')
  end

  def bexrbs
    @bexrbs = News.where(state: "Active", category: "BeXRB")
  end

  def index
    @news = News.where(state: "Active", category: "News").order("pub_date desc")
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
