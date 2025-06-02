# Warb

<p>
  <img src="https://img.shields.io/badge/em_desenvolvimento-lightgreen?label=status"/>
  <img src="https://img.shields.io/badge/0.0.0-lightgreen?label=version"/>
</p>

A Ruby Gem focused on wrap all the functionalities and use cases of the WhatsApp Business API. With Warb you can send messages, audio, images, videos, locations and so much more.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
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

### Find all usage examples

We suggest heading to the `examples/` directory, where you'll find documentation files with plenty of usage examples, organized by **Resources** (**Resources** are the types of messages you can send via WhatsApp using Warb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/warb.
