# frozen_string_literal: true

require "wahoo"

Wahoo.configure do |c|
  c.client_id     = ENV["WAHOO_CLIENT_ID"]
  c.client_secret = ENV["WAHOO_CLIENT_SECRET"]
end

client = Wahoo::Client.new(access_token: ENV.fetch("WAHOO_ACCESS_TOKEN"))

puts "User: #{client.user.get.name}"
puts

client.workouts.list(limit: 10).each do |w|
  line = "#{w.starts&.strftime('%d %b')} · #{w.name}"
  line += " · #{w.distance_km} km" if w.distance_km
  line += " · #{w.duration_human}" if w.duration_human
  line += " · #{w.avg_speed_kmh} km/h" if w.avg_speed_kmh
  puts line
end
