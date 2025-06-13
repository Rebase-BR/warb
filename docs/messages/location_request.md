# Location Request

Location Request Message is an interactive message. That is, the user must interect for a complete flow.

It is used to request the user's location, which can be useful for various purposes, such as finding nearby places.

When the user receives a Location Request message, they will be able to share a location by clicking on the "Share Location" button, which can be their current location or a different selected one.

Once the user shares their location, it will be sent to the webhook configured for the WhatsApp account, allowing you to process the location data as needed.

You can check our [`webhook.rb`](../../examples/webhook.rb) example to see how to handle the location request message in your application.

For more info, see the [WhatsApp documentation for Location Request](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-messages/location-request-messages#:~:text=%2B16505551234-,Webhook%20syntax,-When%20a%20WhatsApp), in the `Webhook syntax` section.

Nevertheless, you can send a location request message like this:

```ruby
Warb.location_request.dispatch(recipient_number, body_text: "Please share your location")
```

For Location Request messages, `body_text` is the unique parameter which can be set, is required, and is used to set the text that will be displayed in the message body.