# Getting Started

This guide walks you from zero to reading a user's workouts.

## 1. Register a Wahoo app

Go to [developers.wahooligan.com](https://developers.wahooligan.com), create an
application (Sandbox first), and note your **Client ID** and **Client Secret**.
Set the redirect URI to where Wahoo should send users back after they authorize.

No device is required to develop — the Sandbox gives you test data.

## 2. Install

```ruby
gem "wahoo"
```

## 3. Configure

```ruby
Wahoo.configure do |c|
  c.client_id     = ENV["WAHOO_CLIENT_ID"]
  c.client_secret = ENV["WAHOO_CLIENT_SECRET"]
  c.redirect_uri  = "https://yourapp.com/wahoo/callback"
end
```

## 4. Authenticate a user (OAuth 2.0)

```ruby
# Step 1 — send the user to Wahoo
url = Wahoo::OAuth.authorize_url(scope: "user_read workouts_read")
# redirect the user's browser to `url`

# Step 2 — in your callback endpoint, exchange the code
tokens = Wahoo::OAuth.exchange_code(params[:code])

# store tokens.access_token and tokens.refresh_token for this user
```

## 5. Read data

```ruby
client = Wahoo::Client.new(access_token: tokens.access_token)

client.user.get.name            # the user's name
client.workouts.list.size       # all their workouts (all pages)
```

## 6. Refresh tokens when they expire

```ruby
if tokens.expired?
  tokens = Wahoo::OAuth.refresh(tokens.refresh_token)
  # save the new tokens
end
```

Next: see [Working with workouts](workouts.md) and [Units & conversions](conversions.md).
     