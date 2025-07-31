# Template

Template messages are used to send a message with a specific template.

This is useful for sending messages that have a predefined structure, such as notifications or alerts.

#### Quick Examples

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance.

List available templates:
```ruby
Warb.template.list
```

Sending template messages:
```ruby
Warb.template.dispatch(recipient_number, **params)
```

#### Listing Templates

**Prerequisites**: In order to view templates, you need to have them available in your business account. For more details, refer to the [Meta documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-message-templates/template-library). Template creation via API will be covered later in this documentation (coming soon).

You can retrieve all available message templates:

```ruby
Warb.template.list
```

##### Optional Parameters

You can optionally filter templates using various parameters:

Limit the number of results:
```ruby
Warb.template.list(limit: 10)
```

Specify which template fields to return:
```ruby
Warb.template.list(fields: ["name", "status", "category"])
```

For a complete list of available fields, refer to the [Meta documentation](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-hsm/#fields).

##### Example Response

```ruby
{
  "data" => [
    {
      "name" => "hello_world",
      "status" => "APPROVED",
      "category" => "UTILITY",
      "language" => "en_US",
      "components" => [ ... ],
      "id" => "1282952826730729"
    },
    {
      "name" => "other_template_001",
      "status" => "APPROVED",
      "category" => "MARKETING",
      "language" => "pt_BR",
      "components" => [ ... ],
      "id" => "1948352829250167"
    }
  ],
  "paging" => {
    "cursors" => {
      "before" => "...",
      "after" => "..."
    }
  }
}
```

#### Sending Template Messages

To send  a template message, you need to provide the template name and the parameters for the template, if any.

```ruby
Warb.template.dispatch(recipient_number, **params)
```

Here, `**params` is a named hash parameters that will be passed to the template, as follow:
| Attribute   | Type              | Required | Description                           |
|-------------|-------------------|----------|---------------------------------------|
| `name`      | `String`          | Yes      | The name of the template to use       |
| `language`  | `String`          | Yes      | The language to use for the template  |
| `resources` | `Array` or `Hash` | No       | The resources to use for the template |

`name` must be the name of a template that has been created in the WhatsApp Business Platform.

`language` must be a valid language code, such as `en_US` for English (United States) or `fr_FR` for French (France). Also, the specified template must support the specified language.

> You can check `Warb::Language` for a list of supported languages.
> If yours isn't there, you can refer to this [list with all supported languages](https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/supported-languages) by WhatsApp.
> Just use the value in the `code` column, and it will work.

`resouces` can be an array or a hash of resources that will be used as parameters for the template. At this point, only `text`, `date_time` and `currency` are supported.

If the template uses named parameters, then `resources` must be a hash, as follow:
```ruby
customer_name = Warb::Resources::Text.new(content: "Name")
purchase_date = Warb::Resources::Text.new("January 1, 2023")

Warb.template.dispatch(recipient_number, resources: {
  customer_name: customer_name,
  purchase_date: purchase_date
}, name: "testing", language: "pt_BR")
```

If the template uses positional parameters, then `resources` must be an array, as follow:
```ruby
customer_name = Warb::Resources::Text.new(content: "Name")
purchase_date = Warb::Resources::DateTime.new("January 1, 2023")

Warb.template.dispatch(recipient_number, resources: [
  customer_name,
  purchase_date
], name: "testing", language: "en_US")
```

In any case, under the hood, the resources instances' method `build_template_named_parameter` or `build_template_positional_parameter` will be called to build the template parameters accordingly.

Instead of instatiating the resources manually, you can use helper methods as follow:
```ruby
Warb.template.dispatch(recipient_number) do |template|
  template.name = "testing"
  template.language = Warb::Language::PORTUGUESE_BR
  template.add_text_parameter(content: "Name")
  template.add_currency_parameter(code: "USD", amount: 11.42)
end
```

Here, `add_text_parameter` and `add_currency_parameter` will build the resources for you with the given named parameters and add them to the template.

Here's a table with all the helper methods you can use to add resources/paramters to the template message:
| Method Name                     | Resource Type               | Description                                      |
|---------------------------------|-----------------------------|--------------------------------------------------|
| `add_text_parameter`            | `Warb::Resources::Text`     | Adds a text parameter to the template            |
| `add_date_time_parameter`       | `Warb::Resources::DateTime` | Adds a date time parameter to the template       |
| `add_currency_parameter`        | `Warb::Resources::Currency` | Adds a currency parameter to the template        |

In the example above, notice we only used named parameters (no positional parameters) as arguments to the add parameter methods.

So, the parameters will be built as positional parameters, and the `resources` will be an array.

Also, the resources will be used to substitute the corresponding parameters in your template, in the same order they were added to the parameters/resources list.

If you don't want to worry about the order of the parameters, you may use named parameters.

For that, you have to pass the parameter name (as defined in your template) as the first argument to the helper method, as follow:
```ruby
Warb.template.dispatch(recipient_number, name: "testing", language: "pt_BR") do |template|
  template.add_text_parameter("customer_name", content: "Name")
  template.add_date_time_parameter("purchase_date", date_time: "January 1, 2023")
end
```

This way, the order of the parameters names in the template and the order they were added with the `add_parameter` methods may be entirely different.

One **IMPORTANT** thing to note is that, once defined, the type of the parameters won't be changed.

So, in the following code:
```ruby
Warb.template.dispatch(recipient_number, name: "testing", language: "pt_BR") do |template|
  template.add_date_time_parameter(date_time: "January 1, 2023")
  template.add_text_parameter("customer_name", content: "Name")
end
```
Your `customer_name` parameter won't behave the way you may expect.

Since the first call to an `add_parameter` method was using the positional parameters syntax, then the internal resources attribute was set to an array, so that means any posterior calls to any `add_parameter` method will simply ignore the named parameter syntax and append the built resource to the list of positional parameters

If the order of the calls was different:
```ruby
Warb.template.dispatch(recipient_number, name: "testing", language: "pt_BR") do |template|
  template.add_text_parameter("customer_name", content: "Name")
  template.add_date_time_parameter(date_time: "January 1, 2023")
  template.add_currency_parameter(code: "USD", amount: 10)
end
```

1. The first call to `add_parameter` method would set the internal resources/parameter to a hash, with a initial key named `customer_name`, pointing to a text resource

2. Then the `DateTime` resource (built in the second call to `add_parameter` method) would be set as value to the key `""` (empty string) in the named parameter hash.

3. Eventually, the `Currency` resource (in the third call do `add_parameter` method) would be set as value to the same key `""` (empty string) as the previous call, which would overwrite the previous resource.

In this case, the call to the api would result in an error, either due to the mismatch of the count of parameters, or due to not having all named parameters defined.

So, make sure to always use the same parameter syntax accordingly to your template.

The add parameter methods also support block building as well:
```ruby
Warb.template.dispatch(recipient_number) do |template|
  template.name = "testing"
  template.language = Warb::Language::ENGLISH_US

  template.add_text_parameter(content: "Name")

  template.add_currency_parameter do |currency|
    currency.code = "USD"
    currency.amount = 11.42
    currency.fallback = "$ 11.42"
  end

  template.add_date_time_parameter do |purchase_date|
    purchase_date.date_time = "Jan 1st, 2024"
  end
end
```

If your template has any media header, you can set it as follow:
| Header Type    | Template Instance Method    | Params                                         |
|----------------|-----------------------------|------------------------------------------------|
| `image`        | `set_image_header`          | `media_id` or `link`                           |
| `video`        | `set_video_header`          | `media_id` or `link`                           |
| `document`     | `set_document_header`       | `media_id` or `link`, `filename`               |
| `location`     | `set_location_header`       | `latitude`, `longitude`, `name`, and `address` |
| `text`         | `set_text_header`           | `content`, `parameter_name`                    |

Every time a call is made to any `set_header` method, a new header will be set, overwriting the previous one.

If you just want to change one attribute or another, `set_header` methods return the related resource, so it is possible to set the values if you keep a hold of such instance
```ruby
Warb.template.dispatch(recipient_number) do |template|
  header = template.set_image_header(media_id: "wrong_media_id")

  header.media_id = "correct_media_id"
end
```

Also, either only one of `media_id` or `link` must be provided.

The `media_id` must be the id of media uploaded previously to WhatsApp Business Platform, while the `link` must be a public acessible URL.

Check the `upload` section for each media related message, like [`image`](./image.md) or [`document`](./document.md), for more info on how to upload and the supported formats.

For the `document` header, `filename` is important because its extension will determine the preview capability on the recipient's device.

For the `location` header, at least `latitude` and `longitude` must be provided.

`set_header` methods will simply instatiate the corresponding resource class with the given parameters, and then, set it as the header attribute.

For `text` header, note that, due to how the WhatsApp Business Platform works, you can't set the entire content for it (the same that happens with the body of the message).

In this case, `set_text_header`, will simply use whatever was given to it as parameter to build the final header in the WhatsApp Business Platform.

So, for example, if your tamplate header was created with `Hello, {{1}}!`, then the text passed to `set_text_header` will simply be substituted in that `{{1}}`.

If your template was defined using named parameters instead (something like `Hello, {{customer_name}}!`), then you must pass the name of the paramter to `set_text_header` as follow:
```ruby
Warb.template.dispatch(recipient_number) do |template|
  template.set_text_header(content: "John", parameter_name: "customer_name")
end
```

When the template instance's `build_payload` method is called (which happens when the message is about to be dispatched), the header param will be created using the `header`'s `build_header` method.

#### Adding Buttons

If your template supports buttons, you can add them using the following methods:

| Button Type        | Template Instance Method      | Params                                    |
|--------------------|-------------------------------|-------------------------------------------|
| `quick_reply`      | `set_quick_reply_button`      | `index`                                   |
| `url`              | `set_dynamic_url_button`      | `index`, `text`                           |
| `copy_code`        | `set_copy_code_button`        | `index`, `coupon_code`                    |
| `voice_call`       | `set_voice_call_button`       | `index`                                   |

You can either use the keyword parameters or set the attributes using a block:

```ruby
Warb.template.dispatch(recipient_number) do |template|
  template.name = "order_confirmation"
  template.language = Warb::Language::ENGLISH_US

  # Add a quick reply button
  template.set_quick_reply_button(index:0)

  # Add a dynamic URL button
  template.set_dynamic_url_button do |button|
    button.index = 1
    button.text = "dynamic-url-suffix"
  end

  # Add a copy code button
  template.set_copy_code_button(index: 2) do |button|
    button.coupon_code = "SAVE20"
  end

  # Add a voice call button
  template.set_voice_call_button(index: 3)
end
```

**Note**: The `index` parameter determines the order of the buttons in the template. Make sure the indices match the button positions defined in your template.
