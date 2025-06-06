# frozen_string_literal: true

require_relative "../lib/warb"

# Configure your variables here

access_token = ""
business_id = ""
sender_id = ""
recipient_number = ""

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

# To send sticker using its ID, you may need to retrieve it first, which can be retrieved this way
file_path = "" # fill this in with the file path pointing to wherever the sticker is located
file_type = "image/webp" # fill this in with the mimetype of the sticker to be uploaded
# only image/webp is allowed for sticker file type
image_id = warb_from_setup.sticker.upload(file_path: file_path, file_type: file_type)
# if you already have an sticker id, you can simply replace the above line with such id

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

# Same as stated above, if you need a sticker id, you can upload it this way
file_path = "" # fill this in with the file path pointing to wherever the sticker is located
file_type = "" # fill this in with the mimetype of the sticker to be uploaded
# allow values for file_type: sticker/aac, sticker/amr, sticker/mpeg, sticker/mp4 or sticker/ogg
image_id = warb_from_setup.sticker.upload(file_path: file_path, file_type: file_type)
# if you already have a sticker id, you can simply replace the above line with such id

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
