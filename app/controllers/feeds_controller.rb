class FeedsController < ApplicationController
  before_action :set_feed, only: [:read, :show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  respond_to :html

  def index
    @feeds = Feed.all
    respond_with(@feeds)
  end

  def read
    @feed.read

    redirect_to @feed
  end

  def show
    respond_with(@feed)
  end

  def new
    @feed = Feed.new(method: "GET", state: "Active", parser_class: "RSS")

    respond_with(@feed)
  end

  def edit
  end

  def create
    @feed = Feed.new(feed_params)
    flash[:notice] = 'Feed was successfully created.' if @feed.save
    respond_with(@feed)
  end

  def update
    flash[:notice] = 'Feed was successfully updated.' if @feed.update(feed_params)
    respond_with(@feed)
  end

  def destroy
    @feed.state = "Passive"
    @feed.save
    respond_with(@feed)
  end

  private
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:url, :state, :last_connected_at, :method, :parser_class, :post_data)
    end
end
