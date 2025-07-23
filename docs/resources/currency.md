# Currency

`Warb::Resources::Currency` is a resource, but different from most other resources, it can't be sent. Instead, it's used in a template message as one of its parameters.

Please, refer to  our [templates messaging documentation](../messages/template.md) for more info.

It represents an amount in a specific currency, which can be set with the following attributes:
| Attribute  | Type               | Required | Description                                                 |
|------------|--------------------|----------|-------------------------------------------------------------|
| `amount`   | `Integer`, `Float` | Yes      | The amount to be represented in the given currency          |
| `code`     | `String`           | Yes      | The code of the currency to be used                         |
| `fallback` | `String`           | No       | A fallback value to be used in case the code can't be found |

Since it is used in template messages, it implements both `build_template_named_parameter` and `build_template_positional_parameter`, which prepares the resource for using as parameter.

If no `fallback` value is given, then a default one, based on the given `amount` and `currency` is used.

In the WhatsApp Business Platform, the `code` will be used to represent the given `amount` according to the specific currency.

But if the given code doesn't exist, or is not supported, then the given `fallback` value will be used instead.

For the `code`, you must use one currency code like `USD` or `BRL`. `Warb::Resources::Currency` offers some of the most used currencies. You can also [check here](https://www.iso.org/iso-4217-currency-codes.html) for more detailed info and other available options.