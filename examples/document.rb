# frozen_string_literal: true

require_relative "../lib/warb"

# Configure your variables here

access_token = ""
business_id = ""
sender_id = ""
recipient_number = ""

document_id = ""
document_link = ""

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

warb_from_setup.document.dispatch(recipient_number, media_id: document_id)
warb_from_setup.document.dispatch(recipient_number, media_id: document_id, filename: "optional_name.pdf")
warb_from_setup.document.dispatch(recipient_number, media_id: document_id, caption: "OPTIONAL - Document caption")
warb_from_setup.document.dispatch(recipient_number, link: document_link)
warb_from_setup.document.dispatch(recipient_number, link: document_link, filename: "optional_name.pdf")
warb_from_setup.document.dispatch(recipient_number, link: document_link, caption: "OPTIONAL - Document caption")

warb_from_setup.document.dispatch(recipient_number) do |builder|
  builder.media_id = document_id
  builder.filename = "optional_name.pdf"
  builder.caption = "OPTIONAL - Document caption"
end

warb_from_setup.document.dispatch(recipient_number) do |builder|
  builder.link = document_link
  builder.filename = "optional_name.pdf"
  builder.caption = "OPTIONAL - Document caption"
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

warb_from_new.document.dispatch(recipient_number, media_id: document_id)
warb_from_new.document.dispatch(recipient_number, media_id: document_id, filename: "optional_name.pdf")
warb_from_new.document.dispatch(recipient_number, media_id: document_id, caption: "OPTIONAL - Document caption")
warb_from_new.document.dispatch(recipient_number, link: document_link)
warb_from_new.document.dispatch(recipient_number, link: document_link, filename: "optional_name.pdf")
warb_from_new.document.dispatch(recipient_number, link: document_link, caption: "OPTIONAL - Document caption")

warb_from_new.document.dispatch(recipient_number) do |builder|
  builder.media_id = document_id
  builder.filename = "optional_name.pdf"
  builder.caption = "OPTIONAL - Document caption"
end

warb_from_new.document.dispatch(recipient_number) do |builder|
  builder.link = document_link
  builder.filename = "optional_name.pdf"
  builder.caption = "OPTIONAL - Document caption"
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.document.dispatch(recipient_number, media_id: document_id)
Warb.document.dispatch(recipient_number, media_id: document_id, filename: "optional_name.pdf")
Warb.document.dispatch(recipient_number, media_id: document_id, caption: "OPTIONAL - Document caption")
Warb.document.dispatch(recipient_number, link: document_link)
Warb.document.dispatch(recipient_number, link: document_link, filename: "optional_name.pdf")
Warb.document.dispatch(recipient_number, link: document_link, caption: "OPTIONAL - Document caption")

Warb.document.dispatch(recipient_number) do |builder|
  builder.media_id = document_id
  builder.filename = "optional_name.pdf"
  builder.caption = "OPTIONAL - Document caption"
end

Warb.document.dispatch(recipient_number) do |builder|
  builder.link = document_link
  builder.filename = "optional_name.pdf"
  builder.caption = "OPTIONAL - Document caption"
end
