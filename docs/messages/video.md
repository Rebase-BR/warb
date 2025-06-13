# Video

For starters, not all video formats are supported by WhatsApp. Here is a table of supported video formats:

| Video Type | Extension | MIME Type    | Max Size |
|------------|-----------|--------------|----------|
| MP4        | `.mp4`    | `video/mp4`  | 16 MB    |
| 3GPP       | `.3gp`    | `video/3gpp` | 16 MB    |

To send a video message, use the `video` dispatch wrapper as follows:

```ruby
recipient_number = "..."
Warb.video.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple video message like this:

```ruby
Warb.video.dispatch(recipient_number, link: "https://example.com/video.mp4")
```

You can also use the block building strategy to send a video message:

```ruby
Warb.video.dispatch(recipient_number) do |video|
  video.link = "https://example.com/video.mp4"
end
```

As seen above, the `link` field is used to set the video file URL. This must be a direct link to a video file hosted online.

Also, if using a link, the video file must be publicly accessible, meaning it should not require any authentication or special permissions to access.

Aside from a link, you can also send a video by using its ID. For that, you need to have the ID of the video file already uploaded to WhatsApp.

#### Upload

Since our `video` wrapper is a media dispatcher, it supports media-related operations, like `upload` and `download` methods.

So, we can use the `upload` method to upload a video file and get its ID:

```ruby
video_id = Warb.video.upload(file_path: "path/to/video.mp4", file_type: "video/mp4")
```

> `file_type` must be one of the supported video types listed [above](#), and `file_path` is the path to the video file you want to upload.

**Note**: At this point, it is not possible to retrieve the ID of a video file that was previously uploaded, so keep the ID returned by the `upload` method for later use.

**Note**: Also, note that uploaded videos are stored on WhatsApp servers for 30 days. After that period, they will be deleted and you won't be able to use the ID anymore.

#### Sending with Video ID

With the video ID in hand, you can use it to send the video message:

```ruby
Warb.video.dispatch(recipient_number, media_id: video_id)
```

You can also use the block building strategy to send a video message with an ID:

```ruby
Warb.video.dispatch(recipient_number) do |video|
  video.media_id = video_id
end
```

**Note**: Either only one of the `link` or `media_id` fields can be set at a time.

#### Downloading Video

You can also download a video file using its ID:

```ruby
Warb.video.download(media_id: video_id, file_path: "path/to/save/video.mp4")
```

This will download the video file to the specified path.

Under the hood, the `download` method will use the `retrieve` method to get the download URL.

With the URL in hand, the `download` method will, in fact, download the file to the specified path.

The `retrieve` method receives a single parameter, which is the `media_id` of the video file you want to retrieve.

```ruby
Warb.video.retrieve(media_id: video_id)
```

And here is a sample response from the `retrieve` method:

```json
{
  "url": "https://lookaside.fbsbx.com/...",
  "mime_type": "video/mp4",
  "sha256": "4b4719...",
  "file_size": 1048576,
  "id": "134183...",
  "messaging_product": "whatsapp"
}
```

#### Deleting Video

You can delete a video file using its ID:

```ruby
Warb.video.delete(video_id)
```

This will delete the video file from WhatsApp servers and return `true` on success.

This is useful if you want to free up space or if you no longer need the video file.