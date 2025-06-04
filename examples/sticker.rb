# frozen_string_literal: true

require_relative "../lib/warb"

# Configure your variables here

access_token = ""
business_id = ""
sender_id = ""
recipient_number = ""

image_id = ""
image_link = ""

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

warb_from_setup.sticker.dispatch(recipient_number, media_id: image_id)
warb_from_setup.sticker.dispatch(recipient_number, link: image_link)

warb_from_setup.sticker.dispatch(recipient_number) do |builder|
  builder.media_id = image_id
end

warb_from_setup.sticker.dispatch(recipient_number) do |builder|
  builder.link = image_link
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

warb_from_new.sticker.dispatch(recipient_number, media_id: image_id)
warb_from_new.sticker.dispatch(recipient_number, link: image_link)

warb_from_new.sticker.dispatch(recipient_number) do |builder|
  builder.media_id = image_id
end

warb_from_new.sticker.dispatch(recipient_number) do |builder|
  builder.link = image_link
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.sticker.dispatch(recipient_number, media_id: image_id)
Warb.sticker.dispatch(recipient_number, link: image_link)

Warb.sticker.dispatch(recipient_number) do |builder|
  builder.media_id = image_id
end

Warb.sticker.dispatch(recipient_number) do |builder|
  builder.link = image_link
end
