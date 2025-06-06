# frozen_string_literal: true

require_relative "../lib/warb"

# Configure your variables here

access_token = ""
business_id = ""
sender_id = ""
recipient_number = ""

video_link = ""

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

# To send video using its ID, you may need to retrieve it first, which can be retrieved this way
file_path = "" # fill this in with the file path pointing to wherever the video is located
file_type = "" # fill this in with the mimetype of the video to be uploaded. allowed values: "video/3gpp" or "video/mp4"
video_id = warb_from_setup.video.upload(file_path: file_path, file_type: file_type)
# if you already have a video id, you can simply replace the above line with such id

warb_from_setup.video.dispatch(recipient_number, media_id: video_id)
warb_from_setup.video.dispatch(recipient_number, media_id: video_id, caption: "OPTIONAL - Image caption")
warb_from_setup.video.dispatch(recipient_number, link: video_link)
warb_from_setup.video.dispatch(recipient_number, link: video_link, caption: "OPTIONAL - Image caption")

warb_from_setup.video.dispatch(recipient_number) do |builder|
  builder.media_id = video_id
  builder.caption = "OPTIONAL - Image caption"
end

warb_from_setup.video.dispatch(recipient_number) do |builder|
  builder.link = video_link
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

# Same as stated above, if you need a video id, you can upload it this way
file_path = "" # fill this in with the file path pointing to wherever the video is located
file_type = "" # fill this in with the mimetype of the video to be uploaded. allowed values: "video/3gpp" or "video/mp4"
video_id = warb_from_setup.video.upload(file_path: file_path, file_type: file_type)
# if you already have a video id, you can simply replace the above line with such id

warb_from_new.video.dispatch(recipient_number, media_id: video_id)
warb_from_new.video.dispatch(recipient_number, media_id: video_id, caption: "OPTIONAL - Image caption")
warb_from_new.video.dispatch(recipient_number, link: video_link)
warb_from_new.video.dispatch(recipient_number, link: video_link, caption: "OPTIONAL - Image caption")

warb_from_new.video.dispatch(recipient_number) do |builder|
  builder.media_id = video_id
  builder.caption = "OPTIONAL - Image caption"
end

warb_from_new.video.dispatch(recipient_number) do |builder|
  builder.link = video_link
  builder.caption = "OPTIONAL - Image caption"
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.video.dispatch(recipient_number, media_id: video_id)
Warb.video.dispatch(recipient_number, media_id: video_id, caption: "OPTIONAL - Image caption")
Warb.video.dispatch(recipient_number, link: video_link)
Warb.video.dispatch(recipient_number, link: video_link, caption: "OPTIONAL - Image caption")

Warb.video.dispatch(recipient_number) do |builder|
  builder.media_id = video_id
  builder.caption = "OPTIONAL - Image caption"
end

Warb.video.dispatch(recipient_number) do |builder|
  builder.link = video_link
  builder.caption = "OPTIONAL - Image caption"
end
