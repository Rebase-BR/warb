# frozen_string_literal: true

require_relative '../lib/warb'

# Configure your variables here

access_token = ''
business_id = ''
sender_id = ''
recipient_number = ''

document_link = ''

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

# To send document using its ID, you may need to retrieve it first, which can be retrieved this way
file_path = '' # fill this in with the file path pointing to wherever the document is located
file_type = '' # fill this in with the mimetype of the document to be uploaded
# allow values for file_type:
# text/plain, application/vnd.ms-excel, application/msword
# application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-powerpoint,
# application/vnd.openxmlformats-officedocument.presentationml.presentation or application/pdf
document_id = warb_from_setup.document.upload(file_path: file_path, file_type: file_type)
# if you already have a document id, you can simply replace the above line with such id

warb_from_setup.document.dispatch(recipient_number, media_id: document_id)
warb_from_setup.document.dispatch(recipient_number, media_id: document_id, filename: 'optional_name.pdf')
warb_from_setup.document.dispatch(recipient_number, media_id: document_id, caption: 'OPTIONAL - Document caption')
warb_from_setup.document.dispatch(recipient_number, link: document_link)
warb_from_setup.document.dispatch(recipient_number, link: document_link, filename: 'optional_name.pdf')
warb_from_setup.document.dispatch(recipient_number, link: document_link, caption: 'OPTIONAL - Document caption')

warb_from_setup.document.dispatch(recipient_number) do |builder|
  builder.media_id = document_id
  builder.filename = 'optional_name.pdf'
  builder.caption = 'OPTIONAL - Document caption'
end

warb_from_setup.document.dispatch(recipient_number) do |builder|
  builder.link = document_link
  builder.filename = 'optional_name.pdf'
  builder.caption = 'OPTIONAL - Document caption'
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

# Same as stated above, if you need a document id, you can upload it this way
file_path = '' # fill this in with the file path pointing to wherever the document is located
file_type = '' # fill this in with the mimetype of the document to be uploaded
# allow values for file_type:
# text/plain, application/vnd.ms-excel, application/msword
# application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-powerpoint,
# application/vnd.openxmlformats-officedocument.presentationml.presentation or application/pdf
document_id = warb_from_setup.document.upload(file_path: file_path, file_type: file_type)
# if you already have a document id, you can simply replace the above line with such id

warb_from_new.document.dispatch(recipient_number, media_id: document_id)
warb_from_new.document.dispatch(recipient_number, media_id: document_id, filename: 'optional_name.pdf')
warb_from_new.document.dispatch(recipient_number, media_id: document_id, caption: 'OPTIONAL - Document caption')
warb_from_new.document.dispatch(recipient_number, link: document_link)
warb_from_new.document.dispatch(recipient_number, link: document_link, filename: 'optional_name.pdf')
warb_from_new.document.dispatch(recipient_number, link: document_link, caption: 'OPTIONAL - Document caption')

warb_from_new.document.dispatch(recipient_number) do |builder|
  builder.media_id = document_id
  builder.filename = 'optional_name.pdf'
  builder.caption = 'OPTIONAL - Document caption'
end

warb_from_new.document.dispatch(recipient_number) do |builder|
  builder.link = document_link
  builder.filename = 'optional_name.pdf'
  builder.caption = 'OPTIONAL - Document caption'
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.document.dispatch(recipient_number, media_id: document_id)
Warb.document.dispatch(recipient_number, media_id: document_id, filename: 'optional_name.pdf')
Warb.document.dispatch(recipient_number, media_id: document_id, caption: 'OPTIONAL - Document caption')
Warb.document.dispatch(recipient_number, link: document_link)
Warb.document.dispatch(recipient_number, link: document_link, filename: 'optional_name.pdf')
Warb.document.dispatch(recipient_number, link: document_link, caption: 'OPTIONAL - Document caption')

Warb.document.dispatch(recipient_number) do |builder|
  builder.media_id = document_id
  builder.filename = 'optional_name.pdf'
  builder.caption = 'OPTIONAL - Document caption'
end

Warb.document.dispatch(recipient_number) do |builder|
  builder.link = document_link
  builder.filename = 'optional_name.pdf'
  builder.caption = 'OPTIONAL - Document caption'
end
