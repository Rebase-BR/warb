# Flow

Flow is a special type of interactive WhatsApp message that provides a "form-like" experience.
With ```Warb.flow``` you can send static (navigate) or dynamic (data exchange) flows, both in draft and published modes.

Prerequisites (Meta)
Business Account + Developer Account
Verified Business to send flows in production WhatsApp (unverified accounts can only test in Meta’s Flow editor)
For dynamic flows: endpoint + encryption configured in Meta (to handle user responses)

### Quick Examples

##### Send a static draft flow:
```ruby
Warb.flow.dispatch(recipient_number, flow_id: "0000000000000000", mode: "draft", screen: "INITIAL", body: "Open flow")
```

##### Send a dynamic draft flow:
```ruby
Warb.flow.dispatch(recipient_number,
  flow_id:     "0000000000000000",
  mode:        "draft",
  flow_action: "data_exchange",
  body:        "Open flow"
)
```

##### Send a dynamic published flow with custom header, body, and footer:
```ruby
Warb.flow.dispatch(recipient_number) do |flow|
  flow.flow_id     = "0000000000000000"
  flow.flow_action = "data_exchange"
  flow.mode        = "published"
  flow.body        = "Hello! Please follow the instructions."
  flow.footer      = "Need help? Reply to this message."

  flow.header = {
    type: "document",
    document: {
      link:     "https://example.com/contract.pdf",
      filename: "contract.pdf"
    }
  }

  flow.flow_cta = "Sign"
end
```

### Dispatching Flow Messages
```ruby
Warb.flow.dispatch(recipient_number, **params, &block)
```
##### Parameters
| Attribute     | Type     | Required                           | Description                                                 |
| ------------- | -------- | ---------------------------------- | ----------------------------------------------------------- |
| `flow_id`     | `String` | Yes                                | The ID of the Flow created in Meta.                         |
| `body`        | `String` | Yes                                | Body text shown in the Flow message.                        |
| `flow_action` | `String` | No                                 | `"navigate"` (default) or `"data_exchange"`.                |
| `mode`        | `String` | Yes if `flow mode == 'draft'`      | `"published"` (default) or `"draft"`.                       |
| `screen`      | `String` | Yes if `flow_action == "navigate"` | Initial screen to navigate to.                              |
| `flow_cta`    | `String` | No                                 | Label for the button that opens the Flow.                   |
| `flow_token`  | `String` | No                                 | Token for dynamic flows (encryption/validation).            |
| `data`        | `Hash`   | No                                 | Prefill data for navigate flows.                            |
| `header`      | `Hash`   | No                                 | Optional header (see below).                                |
| `footer`      | `String` | No                                 | Optional footer text.                                       |

### Supported Headers

You must provide exactly one of the following header types:

##### Text
```ruby
{ type: "text", text: "Flow title" }
```

##### Image
```ruby
{ type: "image", image: { id: "MEDIA_ID" } }
# or
{ type: "image", image: { link: "https://example.com/img.jpg" } }
```

##### Video
```ruby
{ type: "video", video: { id: "MEDIA_ID" } }
# or
{ type: "video", video: { link: "https://example.com/video.mp4" } }
```

##### Document
```ruby
{ type: "document", document: { id: "MEDIA_ID" } }
# or
{ type: "document", document: { link: "https://example.com/file.pdf", filename: "file.pdf" } }
```

##### Note:

id must be obtained from a media upload (Warb.image/video/document.upload).

link must be a public URL. For documents, filename is required to determine preview capabilities.

### Modes and Actions
##### mode

"published" (default): Published flow. Allows customizing header, body, footer, and flow_cta.

"draft": Draft flow. Usable via Meta Flow editor and sometimes on WhatsApp, but some elements (like body text and CTA) may be restricted.

##### flow_action

"navigate" (default) → static flow
Requires screen, can include initial data:
```ruby
Warb.flow.dispatch(recipient_number,
  flow_id: "0000000000000000",
  screen:  "INITIAL",
  body:    "Continue",
  data:    { prefill: { name: "Alice", email: "alice@example.com" } }
)
```

"data_exchange" → dynamic flow
No flow_action_payload (omitted automatically):
```ruby
Warb.flow.dispatch(recipient_number,
  flow_id:     "0000000000000000",
  flow_action: "data_exchange",
  body:        "Fill the form",
)
```

### Block Building

You can also build flows using a block:
```ruby
Warb.flow.dispatch(recipient_number) do |flow|
  flow.flow_id     = "0000000000000000"
  flow.flow_action = "data_exchange"
  flow.mode        = "published"
  flow.body        = "We need some information"

  flow.header = { type: "text", text: "Registration" }
  flow.footer = "Thanks!"

  flow.flow_cta   = "Open"
end
```

### Validations

Before sending, the gem enforces:

flow_id is required → raises ArgumentError: flow_id is required

body is required → raises ArgumentError: body is required for flow message

If flow_action == "navigate" then screen is required →
raises ArgumentError: screen is required for flow_action=navigate

The Meta API may return additional errors (invalid parameters, missing fields, etc.), which are raised as Warb::BadRequest, Warb::RequestError, etc.

Example Scenarios
1) Static / Draft
```ruby
Warb.flow.dispatch(recipient_number,
  flow_id: "0000000000000000",
  screen:  "INITIAL",
  mode:    "draft",
  body:    "Open flow"
)
```

2) Dynamic / Draft
```ruby
Warb.flow.dispatch(recipient_number,
  flow_id:     "0000000000000000",
  flow_action: "data_exchange",
  mode:        "draft",
  body:        "Fill the form"
)
```

3) Dynamic / Published with Document Header
```ruby
Warb.flow.dispatch(recipient_number) do |flow|
  flow.flow_id     = "0000000000000000"
  flow.flow_action = "data_exchange"
  flow.mode        = "published"
  flow.body        = "Please review and sign the document."
  flow.footer      = "Reply if you need assistance."
  flow.flow_cta    = "Sign"

  flow.header = {
    type: "document",
    document: {
      link:     "https://www.thecampusqdl.com/uploads/files/pdf_sample_2.pdf",
      filename: "pdf_sample_2.pdf"
    }
  }
end
```

4) Static / Published with Image Header (id) and Prefill Data
```ruby
image_id = Warb.image.upload(file_path: "banner.jpg", file_type: "image/jpeg")

Warb.flow.dispatch(recipient_number) do |flow|
  flow.flow_id = "0000000000000000"
  flow.mode    = "published"
  flow.body    = "Open and check your data"

  flow.header = { type: "image", image: { id: image_id } }

  flow.screen = "INITIAL"
  flow.data   = { prefill: { name: "John", email: "john@example.com" } }
end
```

### Generated Payload (Reference)

Example payload produced by the gem:
```ruby
{
  "type": "interactive",
  "interactive": {
    "type": "flow",
    "header": { ... },
    "body": { "text": "..." },
    "footer": { "text": "..." },
    "action": {
      "name": "flow",
      "parameters": {
        "flow_message_version": "3",
        "flow_id": "....",
        "flow_action": "navigate" | "data_exchange",
        "mode": "published" | "draft",
        "flow_cta": "Open",
        "flow_token": "TOKEN",
        "flow_action_payload": {
          "screen": "INITIAL",
          "data": { "prefill": { ... } }
        }
      }
    }
  }
}
```