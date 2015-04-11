class AddColorToBexrb < ActiveRecord::Migration
  def change
    add_column :bexrbs, :maxi_prob_color, :string
    add_column :bexrbs, :swift_prob_color, :string
    add_column :bexrbs, :fermi_prob_color, :string
  end
end
