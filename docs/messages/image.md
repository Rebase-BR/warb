# Image

For starters, not all images are supported by WhatsApp. Here is a table of supported images:

| Image Type | Extension | MIME Type      | Max Size |
|------------|-----------|----------------|----------|
| JPEG       | `.jpg`    | `image/jpeg`   | 5 MB     |
| PNG        | `.png`    | `image/png`    | 5 MB     |

To send a image message, use the `image` dispatch wrapper as follows:

```ruby
recipient_number = "..."
Warb.image.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple image message like this:

```ruby
Warb.image.dispatch(recipient_number, link: "https://example.com/image.jpg")
```

You can also use the block building strategy to send a image message:

```ruby
Warb.image.dispatch(recipient_number) do |image|
  image.link = "https://example.com/image.jpg"
end
```

As seen above, the `link` field is used to set the image file URL. This must be a direct link to a file hosted online.

Also, if using a link, the image file must be publicly accessible, meaning it should not require any authentication or special permissions to access.

Aside from a link, you can also send a image by using its ID. For that, you need to have the ID of the image file already uploaded to WhatsApp.

#### Upload

Since our `image` wrapper is a media dispatcher, it supports media-related operations, like `upload` and `download` methods.

So, we can use the `upload` method to upload a image file and get its ID:

```ruby
image_id = Warb.image.upload(file_path: "path/to/image.jpg", file_type: "image/jpeg")
```

> `file_type` must be one of the supported image types listed [above](#), and `file_path` is the path to the image file you want to upload.

**Note**: At this point, it is not possible to retrieve the ID of a image file that was previously uploaded, so keep the ID returned by the `upload` method for later use.

**Note**: Also, note that uploaded images are stored on WhatsApp servers for 30 days. After that period, they will be deleted and you won't be able to use the ID anymore.

#### Sending with Image ID

With the image ID in hand, you can use it to send the image message:

```ruby
Warb.image.dispatch(recipient_number, media_id: image_id)
```

You can also use the block building strategy to send a image message with an ID:

```ruby
Warb.image.dispatch(recipient_number) do |image|
  image.media_id = image_id
end
```

**Note**: Either only one of the `link` or `media_id` fields can be set at a time.

#### Downloading Image

You can also download a image file using its ID:

```ruby
Warb.image.download(media_id: image_id, file_path: "path/to/save/image.jpg")
```

This will download the image file to the specified path.

Under the hood, the `download` method will use the `retrieve` method to get the download URL.

With the URL in hand, the `download` method will, in fact, download the file to the specified path.

The `retrieve` method receives a single parameter, which is the `media_id` of the image file you want to retrieve.

```ruby
Warb.image.retrieve(media_id: image_id)
```

And here is a sample response from the `retrieve` method:

```json
{
  "url": "https://lookaside.fbsbx.com/...",
  "mime_type": "image/jpeg",
  "sha256": "4b4719...",
  "file_size": 1048576,
  "id": "134183...",
  "messaging_product": "whatsapp"
}
```

#### Deleting Image

You can delete a image file using its ID:

```ruby
Warb.image.delete(image_id)
```

This will delete the image file from WhatsApp servers and return `true` on success.

This is useful if you want to free up space or if you no longer need the image file.