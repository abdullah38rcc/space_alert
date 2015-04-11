json.array!(@bexrbs) do |bexrb|
  json.extract! bexrb, :id, :name, :ra, :dec, :orbit_period, :maxi_flux_change_prob, :maxi_data, :swift_flux_change_prob, :swift_average_flux, :swift_data, :fermi_flux_change_prob, :fermi_average_flux, :fermi_data, :combined_plot, :plot_days
  json.url bexrb_url(bexrb, format: :json)
end
