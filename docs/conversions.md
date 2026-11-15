# Units & Conversions

The Wahoo API returns raw units: **meters** for distance/elevation, **seconds**
for duration, **m/s** for speed. `wahoo` adds helpers so you don't convert
by hand.

## On a workout summary

```ruby
summary = client.workouts.get(id).workout_summary

# distance
summary.distance_km        # 45.23
summary.distance_miles     # 28.11

# elevation
summary.ascent_feet        # 1115
summary.descent_feet

# duration
summary.duration_minutes   # 100.2
summary.duration_hours     # 1.67
summary.duration_human     # "1h 40m 12s"

# speed / pace
summary.speed_avg_kmh      # 26.3
summary.speed_avg_mph      # 16.3
summary.speed_avg_pace_per_km  # "2:17 /km"
```

## On a workout (shortcuts)

```ruby
workout = client.workouts.get(id)
workout.distance_km
workout.distance_miles
workout.ascent_feet
workout.duration_human
workout.avg_speed_kmh
workout.avg_pace_per_km
```

## On a route

```ruby
route = client.routes.get(id)
route.distance_km
route.distance_miles
route.ascent_feet
route.descent_feet
```

## Using the raw module directly

All helpers are pure functions in `Wahoo::Conversions`:

```ruby
Wahoo::Conversions.meters_to_km(45230)      # 45.23
Wahoo::Conversions.meters_to_feet(340)      # 1115
Wahoo::Conversions.seconds_to_human(6012)   # "1h 40m 12s"
Wahoo::Conversions.mps_to_kmh(7.3)          # 26.3
Wahoo::Conversions.mps_to_pace_per_km(4.17) # "4:00 /km"
```

## Raw values

Every model keeps the original data if you need it:

```ruby
summary.distance_accum   # 45230.0 (raw meters)
summary.raw              # the full original hash
```
