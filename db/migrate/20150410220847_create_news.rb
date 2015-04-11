class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title, limit: 4000
      t.string :desc, limit: 4000
      t.string :link, limit: 4000
      t.datetime :pub_date
      t.string :image, limit: 4000
      t.string :code
      t.string :state
      t.string :category

      t.timestamps
    end
  end
end
