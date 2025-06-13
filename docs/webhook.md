# Webhook

You need to setup a webhook to receive messages from WhatsApp. The webhook is a URL that WhatsApp will call whenever there is an event related to your WhatsApp Business Account, such as receiving a message or a status update.

Such status or updates include:
- New Messages
- Message delivery status
- Message read status
- Message reaction
- Message template status
- Message interactive list response
- Message interactive reply button response
- Errors responses

To set up a webhook, follow these steps:
1. **Create a Webhook URL**: This is the URL that WhatsApp will call to send you updates. It should be publicly accessible and able to handle POST requests.
2. **Configure the Webhook in WhatsApp**: Go to your WhatsApp Business Account settings and configure the webhook URL. You will need to provide the URL and select the events you want to receive.
3. **Handle Incoming Webhook Requests**: In your application, you need to create an endpoint that can handle incoming POST requests from WhatsApp. This endpoint should parse the incoming data and respond with a 200 OK status to acknowledge receipt of the message.
4. **Verify the Webhook**: WhatsApp will send a verification request to your webhook URL. You need to respond with the `hub.challenge` parameter to verify that you own the webhook URL.
5. **Test the Webhook**: Send a test message to your WhatsApp Business Account to ensure that your webhook is working correctly and that you are receiving updates as expected.

After configuring the webhook in the WhatsApp Business Account settings, for a quick start, you can refer to [webhook.rb example](../examples/webhook.rb) to see how to handle incoming webhook requests in your application.

Or you can refer to the official [Webhook Setup](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/set-up-webhooks) or [Webhook payload structure](https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks/components) for more details.