# frozen_string_literal: true

require_relative '../lib/warb'

# Configure your variables here

access_token = ''
business_id = ''
sender_id = ''
recipient_number = ''

# You can use Resources to create headers for your messages.
text_header = Warb::Resources::Text.as_header('OPTIONAL - Header')
image_header = Warb::Resources::Image.as_header(media_id: image_id)
video_header = Warb::Resources::Video.as_header(link: image_url)

# You can use Action Components to create actions for your messages.
action_component = Warb::Components::ReplyButtonAction.new(['button 1', 'button 2', 'button 3'])

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

warb_from_setup.interactive_reply_button.dispatch(
  recipient_number,
  header: text_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

warb_from_setup.interactive_reply_button.dispatch(
  recipient_number,
  header: image_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

warb_from_setup.interactive_reply_button.dispatch(
  recipient_number,
  header: video_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

warb_from_setup.interactive_reply_button.dispatch(recipient_number) do |builder|
  # OPTIONAL Headers: you can choose between text, image, or video headers.

  builder.add_text_header('Text Header')

  # If you want to use an image header, uncomment the line below and provide a valid or Media ID or Link.
  # builder.add_image_header(media_id: image_id) # or builder.add_image_header(link: image_link)

  # If you want to use a video header, uncomment the line below and provide a valid Media ID or Link.
  # builder.add_video_header(media_id: video_id) # or builder.add_video_header(link: video_link)

  builder.body = 'body'
  builder.footer = 'footer'

  builder.build_action do |action|
    action.buttons_texts = ['button 1', 'button 2', 'button 3']
  end
end

# ############################################ #
# ============== Using Warb.new ============== #
# ############################################ #

warb_from_new = Warb.new(
  access_token: access_token,
  business_id: business_id,
  sender_id: sender_id
)

warb_from_new.interactive_reply_button.dispatch(
  recipient_number,
  header: text_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

warb_from_new.interactive_reply_button.dispatch(
  recipient_number,
  header: image_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

warb_from_new.interactive_reply_button.dispatch(
  recipient_number,
  header: video_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

warb_from_new.interactive_reply_button.dispatch(recipient_number) do |builder|
  # OPTIONAL Headers: you can choose between text, image, or video headers.

  builder.add_text_header('Text Header')

  # If you want to use an image header, uncomment the line below and provide a valid or Media ID or Link.
  # builder.add_image_header(media_id: image_id) # or builder.add_image_header(link: image_link)

  # If you want to use a video header, uncomment the line below and provide a valid Media ID or Link.
  # builder.add_video_header(media_id: video_id) # or builder.add_video_header(link: video_link)

  builder.body = 'body'
  builder.footer = 'footer'

  builder.build_action do |action|
    action.buttons_texts = ['button 1', 'button 2', 'button 3']
  end
end

# ################################################# #
# ============== Using Warb directly ============== #
# ################################################# #

Warb.interactive_reply_button.dispatch(
  recipient_number,
  header: text_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

Warb.interactive_reply_button.dispatch(
  recipient_number,
  header: image_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

Warb.interactive_reply_button.dispatch(
  recipient_number,
  header: video_header,
  body: 'body',
  footer: 'footer',
  action: action_component
)

Warb.interactive_reply_button.dispatch(recipient_number) do |builder|
  # OPTIONAL Headers: you can choose between text, image, or video headers.

  builder.add_text_header('Text Header')

  # If you want to use an image header, uncomment the line below and provide a valid or Media ID or Link.
  # builder.add_image_header(media_id: image_id) # or builder.add_image_header(link: image_link)

  # If you want to use a video header, uncomment the line below and provide a valid Media ID or Link.
  # builder.add_video_header(media_id: video_id) # or builder.add_video_header(link: video_link)

  builder.body = 'body'
  builder.footer = 'footer'

  builder.build_action do |action|
    action.buttons_texts = ['button 1', 'button 2', 'button 3']
  end
end
