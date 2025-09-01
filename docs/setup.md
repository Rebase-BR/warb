# Setup

## Global
You can configure `Warb` globally as follow:

```ruby
Warb.setup do |config|
  config.access_token = "access_token"
  config.sender_id = "sender_id"
end
```

This way, every time you use any method from Warb, like `Warb.message` or `Warb.audio`, the global configuration is going to be used automatically.

So if you're running a Rails Application, you can put this code in an initializer file, like `config/initializers/warb.rb`.

If you're not using Rails, you can put it in your main application file, like `app.rb` or `main.rb`.


## Local

Instead of using the global configuration, you might want to use a different configuration for a specific task. In such cases, it's possible to instatiate a client directly using `Warb.new`:

```ruby
client = Warb.new(access_token: "access_token", sender_id: "sender_id")
client.message.dispatch(...)
```

Also, it is possible to reuse the global configuration but override some of the parameters, like `sender_id`:

```ruby
client = Warb.new(sender_id: "another_id")
# This client will use the global `access_token` but a different `sender_id`
client.message.dispatch(...)
```

Aside from the `access_token` and `sender_id`, you can also pass any other parameter that is supported by the `Warb::Client` class, a logger, or a custom HTTP client.

```ruby
Warb.setup do |config|
  config.logger = Logger.new($stdout) # or any other logger you prefer
  config.adapter = :net_http # or any other HTTP client adapter you prefer
end
```

Also, note that calling `Warb.setup` multiple times **WILL NOT** override the previous configuration, so you can use it to change the global configuration at any time.

## Phone numbers (quality monitoring)

You can fetch all phone numbers attached to your WhatsApp Business Account (WABA) and their quality/operational signals.

Requirements: make sure you have configured a business_id in your global setup (this method uses the business context, not the sender/phone context).
```ruby
Warb.setup do |config|
  config.access_token = "ACCESS_TOKEN"
  config.business_id  = "BUSINESS_ID"      # <-- required here
  config.sender_id    = "SENDER_ID"    # still used for message dispatch
end
```

#### Global usage
```ruby
phones = Warb.list_phone_numbers
```

#### Sample response (unwrapped data array):
```ruby
=> [
  {
    "verified_name"            => "Test",
    "code_verification_status" => "NOT_VERIFIED",
    "display_phone_number"     => "00000000000",
    "quality_rating"           => "GREEN",
    "platform_type"            => "CLOUD_API",
    "throughput"               => { "level" => "STANDARD" },
    "webhook_configuration"    => { "application" => "https://example.com/" },
    "id"                       => "(phone_number_id)"
  }
]
```

#### Notes

This method returns the data array directly. If you need paging cursors, call the raw client:
```ruby
raw = Warb.client.get("phone_numbers", {}, endpoint_prefix: :business_id)
raw.body # => { "data" => [...], "paging" => { "cursors" => {...} } }
```

Non-2xx responses raise Warb::RequestError (or subclasses), so you can rescue them in your app.