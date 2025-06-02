# frozen_string_literal: true

require_relative "../lib/warb"

# Configure your variables here

access_token = ""
business_id = ""
sender_id = ""
recipient_number = ""

# We recommend testing one section at a time, as it can be overwhelming to see all the messages at once.
# So you can comment out the sections you don't want to test.

# ############################################## #
# ============== Using Warb.setup ============== #
# ############################################## #

warb_from_setup = Warb.setup do |config|
  config.access_token = access_token
  config.business_id = business_id
  config.sender_id = sender_id
end

warb_from_setup.message.dispatch(recipient_number, content: 'Hello from warb! Message sent with "content" key')
warb_from_setup.message.dispatch(recipient_number, message: 'Hello from warb! Message sent with "message" key')
warb_from_setup.message.dispatch(recipient_number, text: 'Hello from warb! Message sent with "text" key')

warb_from_setup.message.dispatch(recipient_number) do |builder|
  builder.content = "Hello from warb! Message sent with block builder"
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

warb_from_new.message.dispatch(recipient_number, content: 'Hello from warb! Message sent with "content" key')
warb_from_new.message.dispatch(recipient_number, message: 'Hello from warb! Message sent with "message" key')
warb_from_new.message.dispatch(recipient_number, text: 'Hello from warb! Message sent with "text" key')

warb_from_new.message.dispatch(recipient_number) do |builder|
  builder.content = "Hello from warb! Message sent with block builder"
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.message.dispatch(recipient_number, content: 'Hello from warb! Message sent with "content" key')
Warb.message.dispatch(recipient_number, message: 'Hello from warb! Message sent with "message" key')
Warb.message.dispatch(recipient_number, text: 'Hello from warb! Message sent with "text" key')

Warb.message.dispatch(recipient_number) do |builder|
  builder.content = "Hello from warb! Message sent with block builder"
end
