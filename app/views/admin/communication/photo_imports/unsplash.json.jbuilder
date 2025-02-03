json.total @total
json.total_pages @total_pages
json.results @search do |photo|
  json.id photo['id']
  json.credit "Photo by <a href=\"https://unsplash.com/@#{ photo['user']['username'] }?utm_source=#{ Unsplash.configuration.utm_source }&utm_medium=referral\"> #{ photo['user']['name'] }</a> on <a href=\"https://unsplash.com/?utm_source=#{ Unsplash.configuration.utm_source }&utm_medium=referral\">Unsplash</a>"
  json.thumb photo['urls']['small']
  json.preview photo['urls']['regular']
end
