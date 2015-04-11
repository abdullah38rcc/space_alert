json.array!(@news) do |news|
  json.extract! news, :id, :title, :desc, :link, :pub_date, :image, :code
  json.url news_url(news, format: :json)
end
