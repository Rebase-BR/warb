# Audio

For starters, not all audio formats are supported by WhatsApp. Here is a table of supported audio formats:

| Audio Type | Extension | MIME Type                                                                       | Max Size |
| ---------- | --------- | ------------------------------------------------------------------------------- | -------- |
| AAC        | `.aac`    | `audio/aac`                                                                     | 16 MB    |
| AMR        | `.amr`    | `audio/amr`                                                                     | 16 MB    |
| MP3        | `.mp3`    | `audio/mpeg`                                                                    | 16 MB    |
| MP4 Audio  | `.m4a`    | `audio/mp4`                                                                     | 16 MB    |
| OGG Audio  | `.ogg`    | `audio/ogg` (OPUS codecs only; base `audio/ogg` not supported; mono input only) | 16 MB    |

To send an audio message, use the `audio` dispatch wrapper as follow:

```ruby
recipient_number = "..."
Warb.audio.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple audio message like this:

```ruby
Warb.audio.dispatch(recipient_number, link: "https://example.com/audio.ogg")
```

You can also use the block building strategy to send an audio message:

```ruby
Warb.audio.dispatch(recipient_number) do |audio|
  audio.link = "https://example.com/audio.ogg"
end
```

As seen above, the `link` field is used to set the audio file URL. This must be a direct link to an audio file hosted online.

Also, if using a link, the audio file must be publicly accessible, meaning it should not require any authentication or special permissions to access.

Aside from a link, you can also send an audio by using its ID. For that, you need to have the ID of the audio file already uploaded to WhatsApp.

#### Upload

Since our `audio` wrapper is a media dispatcher, it supports media related operations, like `upload` and `download` method.

So, we can use the `upload` method to upload an audio file and get its ID:

```ruby
audio_id = Warb.audio.upload(file_path: "path/to/audio.ogg", file_type: "audio/ogg")
```

> `file_type` must be one of the supported audio types listed [above](#), and `file_path` is the path to the audio file you want to upload.

**Note**: At this point, it is not possible to retrieve the ID of an audio file that was previously uploaded, so keep the ID returned by the `upload` method for later use.

**Note**: Also, note that uploaded audio are stored in WhatsApp servers for 30 days, after that period they will be deleted and you won't be able to use the ID anymore.


#### Sending with Audio ID

With the audio id in hands, you can use the it to send the audio message:

```ruby
Warb.audio.dispatch(recipient_number, media_id: audio_id)
```
You can also use the block building strategy to send an audio message with an ID:

```ruby
Warb.audio.dispatch(recipient_number) do |audio|
  audio.media_id = audio_id
end
```

**Note**: Either only one of the `link` or `media_id` fields can be set at a time.

#### Downloading Audio

You can also download an audio file using its ID:

```ruby
Warb.audio.download(media_id: audio_id, file_path: "path/to/save/audio.ogg")
```

This will download the audio file to the specified path.

Under the hood, the `download` method will use `retrieve` method to get the download URL.

With the URL in hands, the `download` method will, in fact, download the file to the specified path.

The `retrieve` receives a single parameter, which is the `media_id` of the audio file you want to retrieve.

```ruby
Warb.audio.retrieve(media_id: audio_id)
```

And here is a sample response from the `retrieve` method:

```json
{
  "url": "https://lookaside.fbsbx.com/...",
  "mime_type": "audio/ogg",
  "sha256": "4b4719...",
  "file_size": 4799,
  "id": "134183...",
  "messaging_product": "whatsapp"
}
```

#### Deleting Audio

You can delete an audio file using its ID:

```ruby
Warb.audio.delete(audio_id)
```

This will delete the audio file from WhatsApp servers and return `true` on success.

This is useful if you want to free up space or if you no longer need the audio file.