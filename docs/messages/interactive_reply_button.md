# Interactive Reply Button

An interactive reply button message allows you to send a message with a button that, when clicked, sends a predefined reply back.

You can send, at most, 3 buttons in a single message, which the user can select one of them to reply with.

After the user selects an item from the list, you can handle the selection in your application logic, such as sending a follow-up message or performing an action based on the user's choice.

For that, you need to server a webhook on your own. Check the [webhook example](../../examples/webhook.rb) for a simple implementation.

You can send an interactive reply button message like this:

```ruby
header = Warb::Resources::Text.new(content: "Options").build_header
body = "Select a Language:"
footer = nil
action = Warb::Components::ReplyButtonAction.new(buttons_texts: ["Português", "English", "Español"])

Warb.interactive_reply_button.dispatch(recipient_number, header: header, body: body, footer: footer, action: action)
```

Or you can use the block building strategy to simplify the process:

```ruby
Warb.interactive_reply_button.dispatch(recipient_number) do |message|
  message.set_image_header(media_id: "1341834336894773")

  message.body = "Select a Language:"
  message.footer = nil

  message.build_action do |action|
    action.buttons_texts = ["Português", "English", "Español"]
  end
end
```

or you can build the action with the buttons texts directly, passing them to the `build_action` method, without using the block:

```ruby
Warb.interactive_reply_button.dispatch(recipient_number, action: action) do |message|
  message.set_text_header(content: "Options")
  message.body = "Select a Language:"
  message.footer = nil
  message.build_action(buttons_texts: ["Português", "English", "Español"])
end
```

Aside from text and image headers, you can also set a video or document as header using the respective methods, `set_video_header` and `set_document_header`.

For text header, `set_text_header` receives a string, while for image, video, and document headers, you can pass a `media_id` or a `link` to the media file.
For header, as seen above, you can set it using the following instance methods:
| Method                | Named Parameters               | Positional Parameters  | Respective Resource Class   |
|-----------------------|--------------------------------|------------------------|-----------------------------|
| `set_text_header`     | -                              | the content header     | `Warb::Resources::Text`     |
| `set_image_header`    | `link`, `media_id`             | -                      | `Warb::Resources::Image`    |
| `set_video_header`    | `link`, `media_id`             | -                      | `Warb::Resources::Video`    |
| `set_document_header` | `link`, `media_id`, `filename` | -                      | `Warb::Resources::Document` |

Either `link` or `media_id` can be used, but not both at the same time.

If you're using a `link`, it will be used to download the media file from the provided URL, so it must not require any authentication or special headers to access the file.

If you're using a `media_id`, it must be obtained from a previous upload using the appropriate media upload method — such as `Warb.document.upload`, `Warb.image.upload`, and so on.

The `filename` for the document header is optional, but if provided, it will be used to determine the MIME type of the document.

For the `action` of the message, you can use the [`Warb::Components::ReplyButtonAction`](../components/reply_button_action.md) class to build the action with the buttons texts.