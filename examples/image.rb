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

warb_from_setup.image.dispatch(recipient_number, link: image_link)
warb_from_setup.image.dispatch(recipient_number, link: image_link, caption: "OPTIONAL - Image caption")

# To send image using its ID, you may need to retrieve it first, which can be retrieved this way
file_path = "" # fill this in with the file path pointing to wherever the image is located
file_type = "" # fill this in with the mimetype of the image to be uploaded. allowed values: "image/jpeg" or "image/png"
image_id = warb_from_setup.image.upload(file_path: file_path, file_type: file_type)
# if you already have an image id, you can simply replace the above line with such id

warb_from_setup.image.dispatch(recipient_number, media_id: image_id)
warb_from_setup.image.dispatch(recipient_number, media_id: image_id, caption: "OPTIONAL - Image caption")

warb_from_setup.image.dispatch(recipient_number) do |builder|
  builder.media_id = image_id
  builder.caption = "OPTIONAL - Image caption"
end

warb_from_setup.image.dispatch(recipient_number) do |builder|
  builder.link = image_link
  builder.caption = "OPTIONAL - Image caption"
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

# Same as stated above, if you need an image id, you can upload it this way
file_path = "" # fill this in with the file path pointing to wherever the image is located
file_type = "" # fill this in with the mimetype of the image to be uploaded. allowed values: "image/jpeg" or "image/png"
image_id = warb_from_new.image.upload(file_path: file_path, file_type: file_type)
# if you already have an image id, you can simply replace the above line with such id

warb_from_new.image.dispatch(recipient_number, media_id: image_id)
warb_from_new.image.dispatch(recipient_number, media_id: image_id, caption: "OPTIONAL - Image caption")
warb_from_new.image.dispatch(recipient_number, link: image_link)
warb_from_new.image.dispatch(recipient_number, link: image_link, caption: "OPTIONAL - Image caption")

warb_from_new.image.dispatch(recipient_number) do |builder|
  builder.media_id = image_id
  builder.caption = "OPTIONAL - Image caption"
end

warb_from_new.image.dispatch(recipient_number) do |builder|
  builder.link = image_link
  builder.caption = "OPTIONAL - Image caption"
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.image.dispatch(recipient_number, media_id: image_id)
Warb.image.dispatch(recipient_number, media_id: image_id, caption: "OPTIONAL - Image caption")
Warb.image.dispatch(recipient_number, link: image_link)
Warb.image.dispatch(recipient_number, link: image_link, caption: "OPTIONAL - Image caption")

Warb.image.dispatch(recipient_number) do |builder|
  builder.media_id = image_id
  builder.caption = "OPTIONAL - Image caption"
end

Warb.image.dispatch(recipient_number) do |builder|
  builder.link = image_link
  builder.caption = "OPTIONAL - Image caption"
end
