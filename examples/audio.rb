# frozen_string_literal: true

require_relative "../lib/warb"

# Configure your variables here

access_token = ""
business_id = ""
sender_id = ""
recipient_number = ""

audio_id = ""
audio_link = ""

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

warb_from_setup.audio.dispatch(recipient_number, media_id: audio_id)
warb_from_setup.audio.dispatch(recipient_number, link: audio_link)

warb_from_setup.audio.dispatch(recipient_number) do |builder|
  builder.media_id = audio_id
end

warb_from_setup.audio.dispatch(recipient_number) do |builder|
  builder.link = audio_link
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

warb_from_new.audio.dispatch(recipient_number, media_id: audio_id)
warb_from_new.audio.dispatch(recipient_number, link: audio_link)

warb_from_new.audio.dispatch(recipient_number) do |builder|
  builder.media_id = audio_id
end

warb_from_new.audio.dispatch(recipient_number) do |builder|
  builder.link = audio_link
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.audio.dispatch(recipient_number, media_id: audio_id)
Warb.audio.dispatch(recipient_number, link: audio_link)

Warb.audio.dispatch(recipient_number) do |builder|
  builder.media_id = audio_id
end

Warb.audio.dispatch(recipient_number) do |builder|
  builder.link = audio_link
end
