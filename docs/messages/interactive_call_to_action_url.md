# Interactive Call to Action URL

An interactive call to action URL message allows you to send a message with a button that redirects the user to a specified URL when clicked.

It may seem simple, but you can set a `header`, `body`, and `footer`, along with the `url` and `button_text`.

While `body` and `footer` are simple text fields, the `header` can be a text, an image, a video or even a document.

For all that, the `interactive_call_to_action_url` dispatcher wrapper can be used to facilitate the process of sending this type of message.

You can send an interactive call to action URL message like this:

```ruby
header = Warb::Resources::Text.new(content: "Check this out!").build_header
body = "body"
footer = "footer"
action = Warb::Components::CTAAction.new(url: "https://example.com",  button_text: "Click here")

Warb.interactive_call_to_action_url.dispatch(recipient_number, header: header, body: body, footer: footer, action: action)
```

Here, the block building strategy starts to shine. With it, you don't need to create the `header` and `action` objects manually:

```ruby
Warb.interactive_call_to_action_url.dispatch(recipient_number) do |message|
  # as body and footer are simple text fields, you can set them directly
  message.body = "body"
  message.footer = "footer"

  # for header, there's a helper method to create a text header
  message.add_text_header("Check this out!")

  # and for action, you can use the build_action method to create a CTA action`
  message.build_action(button_text: "Click Here") do |action|
    action.url = "https://example.com"
  end
end
```

Aside from the text header, you can also set an image, video, or document as header using the respective methods, `add_image_header`, `add_video_header`, and `add_document_header`.

Here is an example of using an image as header:

```ruby
Warb.interactive_call_to_action_url.dispatch(recipient_number) do |message|
  message.body = "body"
  message.footer = "footer"

  # set an image as header
  message.add_image_header(link: "https://example.com/image.jpg")

  # the build_action method also returns the built action
  action = message.build_action do |action|
    action.url = "https://example.com"
  end

  # so you could set any attribute of the action after building it
  action.button_text = "Click here"
end
```

And here is an example using a document as header:

```ruby
Warb.interactive_call_to_action_url.dispatch(recipient_number) do |message|
  message.body = "body"
  message.footer = "footer"

  # set a document as header
  # for documents, you can also pass a filename. its extension will be used to determine the MIME type
  message.add_document_header(link: "https://example.com/document.pdf", filename: "document.pdf")

  message.build_action(url: "https://example.com", button_text: "Click here")
end
```

Here is a summary of the fields you can set in the `dispatch` method of the `interactive_call_to_action_url` message:
| Field     | Type                                                       | Description                                                                                   |
|-----------|------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| `header`  | Object                                                     | The header of the message, can be a text, image, video, or document.                          |
| `body`    | String                                                     | The body of the message, a simple text field.                                                 |
| `footer`  | String                                                     | The footer of the message, a simple text field.                                               |
| `action`  | [Warb::Components::CTAAction](../components/cta_action.md) | The action of the message, which contains the URL and button text.                            |


For header, as seen above, you can set it using the following instance methods:
| Method                | Named Parameters   | Positional Parameters  | Respective Resource Class   |
|-----------------------|--------------------|------------------------|-----------------------------|
| `add_text_header`     | -                  | the content header     | `Warb::Resources::Text`     |
| `add_image_header`    | `link`             | -                      | `Warb::Resources::Image`    |
| `add_video_header`    | `link`             | -                      | `Warb::Resources::Video`    |
| `add_document_header` | `link`, `filename` | -                      | `Warb::Resources::Document` |

Under the hood, the set header methods will create the respective resource object and call its `build_header` method to prepare the header for sending.

For the action, the `build_action` instance method will create a `Warb::Components::CTAAction` and return it
