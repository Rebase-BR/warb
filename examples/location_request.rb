# frozen_string_literal: true

require_relative '../lib/warb'

# Configure your variables here

access_token = ''
business_id = ''
sender_id = ''
recipient_number = ''

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

warb_from_setup.location_request.dispatch(recipient_number, body_text: 'Location request body text')

warb_from_setup.location_request.dispatch(recipient_number) do |builder|
  builder.body_text = 'Location request body text'
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

warb_from_new.location_request.dispatch(recipient_number, body_text: 'Location request body text')

warb_from_new.location_request.dispatch(recipient_number) do |builder|
  builder.body_text = 'Location request body text'
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.location_request.dispatch(recipient_number, body_text: 'Location request body text')

Warb.location_request.dispatch(recipient_number) do |builder|
  builder.body_text = 'Location request body text'
end
