# Document

For starters, not all documents are supported by WhatsApp. Here is a table of supported documents:

| Document Type         | Extension | MIME Type                                                                   | Max Size |
|-----------------------|-----------|-----------------------------------------------------------------------------|----------|
| Text                  | `.txt`    | `text/plain`                                                                | 100 MB   |
| Microsoft Excel       | `.xls`    | `application/vnd.ms-excel`                                                  | 100 MB   |
| Microsoft Excel       | `.xlsx`   | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`         | 100 MB   |
| Microsoft Word        | `.doc`    | `application/msword`                                                        | 100 MB   |
| Microsoft Word        | `.docx`   | `application/vnd.openxmlformats-officedocument.wordprocessingml.document`   | 100 MB   |
| Microsoft PowerPoint  | `.ppt`    | `application/vnd.ms-powerpoint`                                             | 100 MB   |
| Microsoft PowerPoint  | `.pptx`   | `application/vnd.openxmlformats-officedocument.presentationml.presentation` | 100 MB   |
| PDF                   | `.pdf`    | `application/pdf`                                                           | 100 MB   |

To send a document message, use the `document` dispatch wrapper as follows:

```ruby
recipient_number = "..."
Warb.document.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple document message like this:

```ruby
Warb.document.dispatch(recipient_number, link: "https://example.com/document.pdf")
```

You can also use the block building strategy to send a document message:

```ruby
Warb.document.dispatch(recipient_number) do |document|
  document.link = "https://example.com/document.pdf"
end
```

As seen above, the `link` field is used to set the document file URL. This must be a direct link to a file hosted online.

Also, if using a link, the document file must be publicly accessible, meaning it should not require any authentication or special permissions to access.

Aside from a link, you can also send a document by using its ID. For that, you need to have the ID of the document file already uploaded to WhatsApp.

#### Upload

Since our `document` wrapper is a media dispatcher, it supports media-related operations, like `upload` and `download` methods.

So, we can use the `upload` method to upload a document file and get its ID:

```ruby
document_id = Warb.document.upload(file_path: "path/to/document.pdf", file_type: "application/pdf")
```

> `file_type` must be one of the supported document types listed [above](#), and `file_path` is the path to the document file you want to upload.

**Note**: At this point, it is not possible to retrieve the ID of a document file that was previously uploaded, so keep the ID returned by the `upload` method for later use.

**Note**: Also, note that uploaded documents are stored on WhatsApp servers for 30 days. After that period, they will be deleted and you won't be able to use the ID anymore.

#### Sending with Document ID

With the document ID in hand, you can use it to send the document message:

```ruby
Warb.document.dispatch(recipient_number, media_id: document_id)
```

You can also use the block building strategy to send a document message with an ID:

```ruby
Warb.document.dispatch(recipient_number) do |document|
  document.media_id = document_id
end
```

**Note**: Either only one of the `link` or `media_id` fields can be set at a time.

#### Downloading Document

You can also download a document file using its ID:

```ruby
Warb.document.download(media_id: document_id, file_path: "path/to/save/document.pdf")
```

This will download the document file to the specified path.

Under the hood, the `download` method will use the `retrieve` method to get the download URL.

With the URL in hand, the `download` method will, in fact, download the file to the specified path.

The `retrieve` method receives a single parameter, which is the `media_id` of the document file you want to retrieve.

```ruby
Warb.document.retrieve(media_id: document_id)
```

And here is a sample response from the `retrieve` method:

```json
{
  "url": "https://lookaside.fbsbx.com/...",
  "mime_type": "application/pdf",
  "sha256": "4b4719...",
  "file_size": 1048576,
  "id": "134183...",
  "messaging_product": "whatsapp"
}
```

#### Deleting Document

You can delete a document file using its ID:

```ruby
Warb.document.delete(document_id)
```

This will delete the document file from WhatsApp servers and return `true` on success.

This is useful if you want to free up space or if you no longer need the document file.