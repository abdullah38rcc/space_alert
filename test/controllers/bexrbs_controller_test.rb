require 'test_helper'

class BexrbsControllerTest < ActionController::TestCase
  setup do
    @bexrb = bexrbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bexrbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bexrb" do
    assert_difference('Bexrb.count') do
      post :create, bexrb: { combined_plot: @bexrb.combined_plot, dec: @bexrb.dec, fermi_average_flux: @bexrb.fermi_average_flux, fermi_data: @bexrb.fermi_data, fermi_flux_change_prob: @bexrb.fermi_flux_change_prob, maxi_data: @bexrb.maxi_data, maxi_flux_change_prob: @bexrb.maxi_flux_change_prob, name: @bexrb.name, orbit_period: @bexrb.orbit_period, plot_days: @bexrb.plot_days, ra: @bexrb.ra, swift_average_flux: @bexrb.swift_average_flux, swift_data: @bexrb.swift_data, swift_flux_change_prob: @bexrb.swift_flux_change_prob }
    end

    assert_redirected_to bexrb_path(assigns(:bexrb))
  end

  test "should show bexrb" do
    get :show, id: @bexrb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bexrb
    assert_response :success
  end

  test "should update bexrb" do
    patch :update, id: @bexrb, bexrb: { combined_plot: @bexrb.combined_plot, dec: @bexrb.dec, fermi_average_flux: @bexrb.fermi_average_flux, fermi_data: @bexrb.fermi_data, fermi_flux_change_prob: @bexrb.fermi_flux_change_prob, maxi_data: @bexrb.maxi_data, maxi_flux_change_prob: @bexrb.maxi_flux_change_prob, name: @bexrb.name, orbit_period: @bexrb.orbit_period, plot_days: @bexrb.plot_days, ra: @bexrb.ra, swift_average_flux: @bexrb.swift_average_flux, swift_data: @bexrb.swift_data, swift_flux_change_prob: @bexrb.swift_flux_change_prob }
    assert_redirected_to bexrb_path(assigns(:bexrb))
  end

  test "should destroy bexrb" do
    assert_difference('Bexrb.count', -1) do
      delete :destroy, id: @bexrb
    end

    assert_redirected_to bexrbs_path
  end
end
