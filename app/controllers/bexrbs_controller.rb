require "open-uri"

class BexrbsController < ApplicationController
  before_action :set_bexrb, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  respond_to :html

  def index
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
