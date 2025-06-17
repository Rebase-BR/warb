# Template Message

Template messages are used to send a message with a specific template.

This is useful for sending messages that have a predefined structure, such as notifications or alerts.

To send  a template message, you need to provide the template name and the parameters for the template, if any.

```ruby
Warb.template.dispatch(recipient_number, "template_name", **params)
```

Here, `**params` is a named hash parameters that will be passed to the template, as follow:
| Attribute   | Type              | Required | Description                           |
|-------------|-------------------|----------|---------------------------------------|
| `name`      | `String`          | Yes      | The name of the template to use       |
| `language`  | `String`          | Yes      | The language to use for the template  |
| `resources` | `Array` or `Hash` | No       | The resources to use for the template |

`name` must be the name of a template that has been created in the WhatsApp Business Platform.

`language` must be a valid language code, such as `en_US` for English (United States) or `fr_FR` for French (France). Also, the specified template must support the specified language.

> You can check `Warb::Langeuage` for a list of supported languages.
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

Here, `add_text_parameter`, `add_currency_parameter` will build the resource for you with the given named parameters and add it to the template.

So here's a table with all the helper methods you can use to add resources to the template:
| Method Name                     | Resource Type               | Description                                      |
|---------------------------------|-----------------------------|--------------------------------------------------|
| `add_text_parameter`            | `Warb::Resources::Text`     | Adds a text parameter to the template            |
| `add_date_time_parameter`       | `Warb::Resources::DateTime` | Adds a date time parameter to the template       |
| `add_currency_parameter`        | `Warb::Resources::Currency` | Adds a currency parameter to the template        |

In the example above, notice we only used named parameters (no positional parameters) as arguments to the add parameters. So, the parameters will be built as positional parameters, and the `resources` will be an array.

To use named parameters, you have to pass the parameter name (as defined in your template) as the first argument to the helper method, as follow:
```ruby
Warb.template.dispatch(recipient_number, name: "testing", language: "pt_BR") do |template|
  template.add_text_parameter("customer_name", content: "Name")
  template.add_date_time_parameter("purchase_date", "January 1, 2023")
end
```

One **IMPORTANT** thing to note is that, once defined, the type of the parameters won't be changed.

So, in the following code:
```
Warb.template.dispatch(recipient_number, name: "testing", language: "pt_BR") do |template|
  template.add_date_time_parameter(date_time: "January 1, 2023")
  template.add_text_parameter("customer_name", content: "Name")
end
```
Your date_time parameter will be incorrect, and eventually, an error will be returned from the API.

If the order of the calls were different:
```
Warb.template.dispatch(recipient_number, name: "testing", language: "pt_BR") do |template|
  template.add_text_parameter("customer_name", content: "Name")
  template.add_date_time_parameter(date_time: "January 1, 2023")
end
```

Then, the parameter name passed would just be ignored, and the resource would be added to the end of the parameters list, since it was defined as positional parameters due to the first call.

Anyway, make sure to always use the same parameters accordingly to your template (or you could overwrite the `resources` attributes direclty, with `template.resources = nil # [] or {}`).

The add parameters method also supports block building as well:
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