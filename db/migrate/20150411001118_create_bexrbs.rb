class CreateBexrbs < ActiveRecord::Migration
  def change
    create_table :bexrbs do |t|
      t.string :name
      t.string :url
      t.string :ra
      t.string :dec
      t.string :orbit_period
      t.string :maxi_flux_change_prob
      t.string :maxi_average_flux
      t.string :maxi_data
      t.string :maxi_url
      t.string :swift_flux_change_prob
      t.string :swift_average_flux
      t.string :swift_data
      t.string :swift_url
      t.string :fermi_flux_change_prob
      t.string :fermi_average_flux
      t.string :fermi_data
      t.string :fermi_url
      t.string :combined_plot
      t.string :plot_days

      t.timestamps
    end
  end
end
