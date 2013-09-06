json.array!(@trackers) do |tracker|
  json.extract! tracker, 
  json.url tracker_url(tracker, format: :json)
end
