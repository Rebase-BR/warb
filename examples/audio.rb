# frozen_string_literal: true

require_relative '../lib/warb'

# Configure your variables here

access_token = ''
business_id = ''
sender_id = ''
recipient_number = ''

audio_link = ''

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

# To send audio using its ID, you may need to retrieve it first, which can be retrieved this way
file_path = '' # fill this in with the file path pointing to wherever the audio is located
file_type = '' # fill this in with the mimetype of the audio to be uploaded
# allow values for file_type: audio/aac, audio/amr, audio/mpeg, audio/mp4 or audio/ogg
audio_id = warb_from_setup.audio.upload(file_path: file_path, file_type: file_type)
# if you already have an audio id, you can simply replace the above line with such id

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

# Same as stated above, if you need an audio id, you can upload it this way
file_path = '' # fill this in with the file path pointing to wherever the audio is located
file_type = '' # fill this in with the mimetype of the audio to be uploaded
# allow values for file_type: audio/aac, audio/amr, audio/mpeg, audio/mp4 or audio/ogg
audio_id = warb_from_setup.audio.upload(file_path: file_path, file_type: file_type)
# if you already have an audio id, you can simply replace the above line with such id

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
