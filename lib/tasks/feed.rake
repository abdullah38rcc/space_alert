require "open-uri"

namespace :feed do
  desc "TODO"
  task read: :environment do
  	Feed.where(state: "Active").each { |feed| 
  		feed.read
  	}
  end

end
