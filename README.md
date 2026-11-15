# wahoo-ruby

A complete Ruby client for the [Wahoo Cloud API](https://cloud-api.wahooligan.com/).
OAuth 2.0 (standard + PKCE), full CRUD for workouts, routes, plans, power zones
and the user, file uploads, webhooks — with first-class models, automatic
pagination, rich unit conversions, and automatic retries.

## Installation

```ruby
gem "wahoo"
```

## Configuration

```ruby
Wahoo.configure do |c|
  c.client_id     = ENV["WAHOO_CLIENT_ID"]
  c.client_secret = ENV["WAHOO_CLIENT_SECRET"]
  c.redirect_uri  = "https://yourapp.com/wahoo/callback"
end
```

## OAuth 2.0

Standard flow:

```ruby
url    = Wahoo::OAuth.authorize_url(scope: "user_read workouts_read")
tokens = Wahoo::OAuth.exchange_code(params[:code])     # in your callback
tokens = Wahoo::OAuth.refresh(tokens.refresh_token) if tokens.expired?
```

PKCE flow (public apps, no secret):

```ruby
verifier  = Wahoo::OAuth.generate_code_verifier
challenge = Wahoo::OAuth.code_challenge_for(verifier)

url = Wahoo::OAuth.authorize_url(scope: "user_read workouts_read",
                                 code_challenge: challenge)
# store `verifier`, then in your callback:
tokens = Wahoo::OAuth.exchange_code(params[:code], code_verifier: verifier)
```

## Client

```ruby
client = Wahoo::Client.new(access_token: tokens.access_token)
```

### User

```ruby
client.user.get                         # Wahoo::Models::User
client.user.update(weight: 72, gender: 0)
```

### Workouts (full CRUD)

```ruby
client.workouts.list                    # all pages, as models
client.workouts.list(limit: 50)
client.workouts.get(id)
client.workouts.create(name: "Ride", workout_token: "abc",
                       workout_type_id: 0, starts: Time.now.iso8601, minutes: 60)
client.workouts.update(id, name: "New name")
client.workouts.delete(id)
client.workouts.plans(id)               # plans attached to a workout
client.workouts.summary(id)             # the workout summary
```

Workout helpers:

```ruby
w = client.workouts.get(id)
w.workout_type        # "BIKING" (from workout_type_id)
w.completed?          # has a summary?
w.distance_km         # conversions (API returns string decimals)
w.duration_human      # "1h 40m 12s"
w.avg_speed_kmh
```

### Routes (full CRUD, FIT upload)

```ruby
client.routes.list
client.routes.get(id)
client.routes.create(file: "route.fit", external_id: "r1",
                     provider_updated_at: Time.now.iso8601, name: "My route",
                     start_lat: 47.15, start_lng: 27.60, distance: 45000, ascent: 340)
client.routes.update(id, name: "Renamed")
client.routes.delete(id)
```

### Plans (full CRUD)

```ruby
client.plans.list
client.plans.get(id)
client.plans.create(file: "plan.json", external_id: "p1",
                    provider_updated_at: Time.now.iso8601)
client.plans.update(id, filename: "plan.json", provider_updated_at: Time.now.iso8601)
client.plans.delete(id)
```

### Power zones (full CRUD)

```ruby
client.power_zones.list
client.power_zones.get(id)
client.power_zones.create(ftp: 300, zone_1: 100, workout_type_id: 0)
client.power_zones.update(id, ftp: 320)
client.power_zones.delete(id)
```

### Workout file uploads (async)

```ruby
upload = client.uploads.create(file: "ride.fit", time_zone: "Europe/Bucharest")
upload.status                    # "pending"

# poll until processed
upload = client.uploads.get(upload.token)
upload.complete?                 # then upload.workout_id is available
```

### Deauthorize

```ruby
client.deauthorize               # revokes your app's access for the user
```

## Webhooks

Set your webhook URL and token in the developer portal (requires `offline_data`
scope). Then handle incoming calls:

```ruby
Wahoo.configure { |c| c.webhook_secret = "your_token" }

event = Wahoo::Webhooks::Handler.verify_token!(request.raw_post)
if event.workout_summary?
  event.user_id                       # user.id
  event.workout_summary.distance_km
  event.workout                       # the nested workout
end
```

See `examples/rails_webhook_controller.rb`.

## Data types

```ruby
Wahoo::Data::WORKOUT_TYPES[0]            # "BIKING"
Wahoo::Data::WORKOUT_TYPE_FAMILIES[0]    # "BIKING"
Wahoo::Data::WORKOUT_TYPE_LOCATIONS[1]   # "OUTDOOR"
```

## Rate limiting & retries

Wahoo sends three windows (day, hour, 5-min). The client retries automatically
on 429 / 5xx with backoff:

```ruby
Wahoo.configure do |c|
  c.max_retries   = 3
  c.retry_backoff = 2
end

# inspect limits from a raw response if needed:
# resp.rate_limit            # { day:, hour:, five_min: }
# resp.rate_limit_remaining
# resp.rate_limit_reset
```

## Errors

```ruby
rescue Wahoo::Unauthorized         # 401
rescue Wahoo::Forbidden            # 403 (missing scope)
rescue Wahoo::UnprocessableEntity  # 422 (bad params / app not approved)
rescue Wahoo::RateLimited => e     # 429, e.retry_after
rescue Wahoo::Error => e           # e.status, e.body
```

## CLI

```bash
WAHOO_CLIENT_ID=... WAHOO_CLIENT_SECRET=... bundle exec wahoo-oauth-token
```

## License

MIT
