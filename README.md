# Warb

<p>
  <img src="https://img.shields.io/badge/em_desenvolvimento-lightgreen?label=status"/>
  <img src="https://img.shields.io/badge/0.0.0-lightgreen?label=version"/>
</p>

A Ruby Gem focused on wrap all the functionalities and use cases of the WhatsApp Business API. With Warb you can send messages, audio, images, videos, locations and so much more.

## Installation

Add `warb` to your bundle

```ruby
bundle add warb
```

or add it manually to your Gemfile if you prefer.

```ruby
gem 'warb'
```

## Configuration

If you don't have a **facebook developer account**, **business portfolio** and **meta app** created yet, please redirect to this [official documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/get-started) to get started.

### Rails

To use Warb in your Rails application first you will need to initialize it in `config/initializers/warb.rb`:

```ruby
Warb.setup do |config|
  config.access_token = <YOUR_WHATSAPP_BUSINESS_ACCESS_TOKEN>
  config.business_id = <YOUR_WHATSAPP_BUSINESS_ID>
  config.sender_id = <YOUR_WHATSAPP_BUSINESS_PHONE_ID>
  config.adapter = <YOUR_ADAPTER_CHOICE> # defaults to Faraday.default_adapter (which is "":net_http" at the moment)
  config.logger = <YOUR_PERSONALIZED_LOGGER> # defaults to Logger.new($stdout)
end
```

If you would like a more direct way to use it, you can always instanciate it directly:

```ruby
warb = Warb.new(
  access_token: <YOUR_WHATSAPP_BUSINESS_ACCESS_TOKEN>,
  business_id: <YOUR_WHATSAPP_BUSINESS_ID>,
  sender_id: <YOUR_WHATSAPP_BUSINESS_PHONE_ID>
  adapter: <YOUR_ADAPTER_CHOICE> # defaults to Faraday.default_adapter (which is "":net_http" at the moment)
  logger: <YOUR_PERSONALIZED_LOGGER> # defaults to Logger.new($stdout)
)
```

## Usage

### Initial Steps

Warb is simple to use — either directly from the module or via an instance.

The **first** and **second** usage modes share a common global configuration instance. The **third** mode, however, creates a new configuration instance, allowing you to define separate local configurations **based on the global configuration (if it exists)** when needed.

1. From the Warb module:
```ruby
Warb.message.dispatch(recipient_number, message: "Hello from warb!")
```

2. From the Warb instance returned from `.setup`:
```ruby
warb = Warb.setup { |config| ... }

warb.message.dispatch(recipient_number, message: "Hello from warb!")
```

3. From the Warb instance return from `.new`:
```ruby
warb = Warb.new(...)

warb.message.dispatch(recipient_number, message: "Hello from warb!")
```

### What more can we do?

You can also pass a block to the `dispatch` method, which look like this:

```ruby
Warb.message.dispatch(recipient_number) do |builder|
  builder.message = "Hello from warb!"
end
```

### What types of messages can I send?

Warb implements the main types of WhatsApp messages, you can follow the message types [`here`](docs/messages/README.md#messages-types)

examples:

```ruby

warb = Warb.new(...)

warb.message.dispatch(...)
warb.audio.dispatch(...)
warb.video.dispatch(...)
warb.image.dispatch(...)
...
```

### Find all usage examples

We suggest heading to the [`examples`](examples) directory, where you'll find documentation files with plenty of usage examples, organized by **Resources** (**Resources** are the types of messages you can send via WhatsApp using Warb).

You can also check the [`docs`](docs/README.md) for a more structured overview of the available resources and their usage.

### Webhook Support

You might want to take action in response to messages users send. For example:

1. A user sends a message like: “generate an image based on...”
2. You receive the message, so you mark it as read to let the user know their request was acknowledged.
3. Since the operation might take some time, you send a typing indicator to show that the request is being processed.

To enable this kind of flow, you’ll need to know **when** a message is received. For that, you’ll need to run your own server to listen for incoming webhook events and respond accordingly.

> ⚠️ **Note:** This gem **does not** provide built-in support for webhooks.
> However, you can look at [`examples/webhook.rb`](examples/webhook.rb) for a starting point on how to implement it. Also, check the [official documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks/payload-examples) for more details if you get stuck.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/warb.
