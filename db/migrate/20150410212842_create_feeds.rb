class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :state
      t.datetime :last_connected_at

      t.timestamps
    end
  end
end
