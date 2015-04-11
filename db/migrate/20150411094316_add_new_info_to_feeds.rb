class AddNewInfoToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :parser_class, :string
    add_column :feeds, :post_data, :text
    add_column :feeds, :method, :string
  end
end
