# Date Time

`Warb::Resources::DateTime` is a resource, but different from most other resources, it can't be sent. Instead, it's used in a template message as one of its parameters.

Please, refer to  our [templates messaging documentation](../messages/template.md) for more info.

It simply represents a date time object, with the unique param/attribute being `date_time`.

Although its name is `date_time`, its content can be any string, like `"January 1st"`, `"2020-01-01"` or `"Wednesday, Jan, 1st, 2020"`.

Since it is used in template messages, it implements both `build_template_named_parameter` and `build_template_positional_parameter`, which prepares the resource for using as parameter.