# Sticker

For starters, not all stickers are supported by WhatsApp. Here is a table of supported stickers:

| Sticker Type    | Extension | MIME Type    | Max Size |
|-----------------|-----------|--------------|----------|
| WebP (static)   | `.webp`   | `image/webp` | 100 KB   |
| WebP (animated) | `.webp`   | `image/webp` | 500 KB   |

To send a sticker message, use the `sticker` dispatch wrapper as follows:

```ruby
recipient_number = "..."
Warb.sticker.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple sticker message like this:

```ruby
Warb.sticker.dispatch(recipient_number, link: "https://example.com/sticker.webp")
```

You can also use the block building strategy to send a sticker message:

```ruby
Warb.sticker.dispatch(recipient_number) do |sticker|
  sticker.link = "https://example.com/sticker.webp"
end
```

As seen above, the `link` field is used to set the sticker file URL. This must be a direct link to a file hosted online.

Also, if using a link, the sticker file must be publicly accessible, meaning it should not require any authentication or special permissions to access.

Aside from a link, you can also send a sticker by using its ID. For that, you need to have the ID of the sticker file already uploaded to WhatsApp.

#### Upload

Since our `sticker` wrapper is a media dispatcher, it supports media-related operations, like `upload` and `download` methods.

So, we can use the `upload` method to upload a sticker file and get its ID:

```ruby
sticker_id = Warb.sticker.upload(file_path: "path/to/sticker.webp", file_type: "image/webp")
```

> `file_type` must be one of the supported sticker types listed [above](#), and `file_path` is the path to the sticker file you want to upload.

**Note**: At this point, it is not possible to retrieve the ID of a sticker file that was previously uploaded, so keep the ID returned by the `upload` method for later use.

**Note**: Also, note that uploaded stickers are stored on WhatsApp servers for 30 days. After that period, they will be deleted and you won't be able to use the ID anymore.

#### Sending with Sticker ID

With the sticker ID in hand, you can use it to send the sticker message:

```ruby
Warb.sticker.dispatch(recipient_number, media_id: sticker_id)
```

You can also use the block building strategy to send a sticker message with an ID:

```ruby
Warb.sticker.dispatch(recipient_number) do |sticker|
  sticker.media_id = sticker_id
end
```

**Note**: Either only one of the `link` or `media_id` fields can be set at a time.

#### Downloading Sticker

You can also download a sticker file using its ID:

```ruby
Warb.sticker.download(media_id: sticker_id, file_path: "path/to/save/sticker.webp")
```

This will download the sticker file to the specified path.

Under the hood, the `download` method will use the `retrieve` method to get the download URL.

With the URL in hand, the `download` method will, in fact, download the file to the specified path.

The `retrieve` method receives a single parameter, which is the `media_id` of the sticker file you want to retrieve.

```ruby
Warb.sticker.retrieve(media_id: sticker_id)
```

And here is a sample response from the `retrieve` method:

```json
{
  "url": "https://lookaside.fbsbx.com/...",
  "mime_type": "image/webp",
  "sha256": "4b4719...",
  "file_size": 1048576,
  "id": "134183...",
  "messaging_product": "whatsapp"
}
```

#### Deleting Sticker

You can delete a sticker file using its ID:

```ruby
Warb.sticker.delete(sticker_id)
```

This will delete the sticker file from WhatsApp servers and return `true` on success.

This is useful if you want to free up space or if you no longer need the sticker file.