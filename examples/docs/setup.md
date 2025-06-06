# Setup

## Global
You can configure `Warb` globally as follow:

```ruby
Warb.setup do |config|
  config.access_token = "..."
  config.sender_id = "..."
end
```

This way, every time you use any method from Warb, like `Warb.message` or `Warb.audio`, the global configuration is going to be used automatically.

## Local

Instead of using the global configuration, you might want to use a different configuration for a specific job. In such cases, it's possible to instatiate a client directly using `Warb.new` as follows:

```ruby
client = Warb.new(access_token: "...", sender_id: "...")
client.message.dispatch(...)
```
