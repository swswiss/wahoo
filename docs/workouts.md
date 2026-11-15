# Working with Workouts

## List all workouts

Pagination is automatic — you get every page as models:

```ruby
client.workouts.list                 # all workouts
client.workouts.list(limit: 50)      # stop after 50
client.workouts.list(per_page: 100)  # 100 per request
```

## Get one workout

```ruby
workout = client.workouts.get(123)
workout.name
workout.starts          # a Time
workout.distance_km
workout.duration_human
```

## Access the summary metrics

```ruby
s = workout.workout_summary
s.power_avg
s.heart_rate_avg
s.calories_accum
s.distance_km
s.ascent_feet
```

## Iterate

```ruby
client.workouts.list.each do |w|
  puts "#{w.name}: #{w.distance_km} km in #{w.duration_human}"
end
```

## Errors

```ruby
begin
  client.workouts.list
rescue Wahoo::Unauthorized
  # token expired — refresh it
rescue Wahoo::RateLimited => e
  # the client already retried; if it still fails, back off e.retry_after
rescue Wahoo::Error => e
  warn "Wahoo error #{e.status}: #{e.message}"
end
```
