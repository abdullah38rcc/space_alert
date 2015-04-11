json.array!(@feeds) do |feed|
  json.extract! feed, :id, :url, :state, :last_connected_at
  json.url feed_url(feed, format: :json)
end
