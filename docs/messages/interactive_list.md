# Interactive List

**Note**: It is recommended to read the [interactive reply button message](./interactive_reply_button.md) documentation before reading this one, as it shares many similarities with the interactive list message.

An interactive list message allows you to create a list of items that the user can select from.

This is useful for scenarios where you want to present multiple options to the user and let them choose one.

After the user selects an item from the list, you can handle the selection in your application logic, such as sending a follow-up message or performing an action based on the user's choice.

For that, you need to server a webhook on your own. Check the [webhook example](../../examples/webhook.rb) for a simple implementation.

It may seem similar to the interactive reply button message, but the list message allows you to present more options and also allows the user to select an item from the list.

Based on the one provided in the [interactive reply button message](./interactive_reply_button.md) documentation, let's create a simple interactive list message, step by step.

Create the header, body, and footer of the message:

```ruby
header = Warb::Resources::Text.new(content: "Language Selection").build_header
body = "Choose your preferred language"
footer = "You can change it latter"
```

Until here, nothing new, we just created the header, body, and footer of the message as usual.

But as with the interactive reply button message, we need to create the list of items that the user can select from.

And in the same way, it is done using the corresponding `action`, which in this case, is the `Warb::Components::ListAction`.

For reply buttons, we simply instantiate the corresponding action with the available options, but for the list message, the options go inside another component.

Actually, aside from the action itself, there are two more components that we need to create: the `Warb::Components::Section` and the `Warb::Components::Row`.

Rows go inside sections, and sections go inside the action. And the available options are the rows.

Let's start with a single section:
```ruby
portuguese_row = Warb::Components::Row.new(title: "Português")
english_row = Warb::Components::Row.new(title: "English")
spanish_row = Warb::Components::Row.new(title: "Español")

section = Warb::Components::Section.new title: "Languages", rows: [portuguese_row, english_row, spanish_row]

action = Warb::Components::ListAction.new button_text: "Select", sections: [section]
```

Then, with everything ready, we can send the message:

```ruby
Warb.interactive_list.dispatch(recipient_number, header: header,  body: body,  footer: footer,  action: action)
```

Now, let's put everything together in a single code snippet:

```ruby
header = Warb::Resources::Text.new(content: "Language Selection").build_header
header = nil
body = "Choose your preferred language"
footer = "You can change it latter"

portuguese_row = Warb::Components::Row.new(title: "Português")
english_row = Warb::Components::Row.new(title: "English")
spanish_row = Warb::Components::Row.new(title: "Español")

section = Warb::Components::Section.new title: "Languages", rows: [portuguese_row, english_row, spanish_row]

action = Warb::Components::ListAction.new button_text: "Select", sections: [section]

Warb.interactive_list.dispatch(recipient_number, header: header,  body: body,  footer: footer,  action: action)
```

Using the block strategy allows you to create the message in a more readable way, as shown below:

```ruby
Warb.interactive_list.dispatch(recipient_number) do |message|
  message.body = "Choose your preferred language"
  message.footer = "You can change it later"

  message.set_text_header("Language Selection")

  message.build_action do |action|
    action.button_text = "Select"

    section = action.add_section(title: nil)
    section.add_row(title: "Português")
    section.add_row(title: "English")
    section.add_row(title: "Español")
    section.add_row(title: "Français")
    section.add_row(title: "Deutsch")
    section.add_row(title: "Italiano")
    section.add_row(title: "Nederlands")
    section.add_row(title: "Русский")
    section.add_row(title: "中文")
    section.add_row(title: "日本語")
  end
end
```

As seen above, one obvious difference from interactive list to interactive reply button is that the list message allows up to 10 options, while the reply button message allows only up to 3 options.

One other difference is that the list message only supports text headers, while the reply button message supports both text and media headers.

And one side note, is that, the section title is not required, if you're using only one section. You could omit it, it was just added to make it more readable.

Now let's see an interactive list message with multiple sections:

```ruby
Warb.interactive_list.dispatch(recipient_number) do |message|
  message.body = "Choose your preferred language"
  message.footer = "You can change it later"

  message.set_text_header("Language Selection")

  message.build_action do |action|
    action.button_text = "Select"

    american_section = action.add_section(title: "American Languages")
    american_section.add_row(title: "English (USA)")
    american_section.add_row(title: "Português (Brasil)")

    european_section = action.add_section(title: "European Languages")
    european_section.add_row(title: "English (UK)")
    european_section.add_row(title: "Português (Portugal)")
    european_section.add_row(title: "Français")
    european_section.add_row(title: "Deutsch")
    european_section.add_row(title: "Italiano")

    asian_section = action.add_section(title: "Asian Languages")
    asian_section.add_row(title: "中文 (Chinese)")
    asian_section.add_row(title: "日本語 (Japanese)")
    asian_section.add_row(title: "Русский (Central Asia)")
  end
end
```

Here, we keep the same total amount of options, but we split them into three sections, each with its own title.

And since we are using more than one section, the title for each section is required, otherwise, it would not be clear what the options are about.

Here is a table summarizing the differences between the interactive list and interactive reply button messages:
| Feature                     | Interactive List Message | Interactive Reply Button Message |
|-----------------------------|--------------------------|-----------------------------------|
| Maximum Options             | 10                       | 3                                 |
| Header Types                | Text only                | Text and Media                    |
| Section Support             | Yes                      | No                                |
| Row Support                 | Yes                      | No                                |
| Action Type                 | ListAction               | ReplyButtonAction                 |
| Button Text                 | Yes                      | Yes                               |
| Footer Support              | Yes                      | Yes                               |
| Body Support                | Yes                      | Yes                               |
| Customization               | High                     | Medium                            |
This table summarizes the key differences between the two types of interactive messages, helping you choose the right one for your use case.

And here is a table summarizing the components used in the interactive list message:
| Component                                                    | Description                                                                       | Named Paremeters                                                                 |
|--------------------------------------------------------------|-----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| [Warb::Components::Row](../components/row.md)                | Represents a single row in the list, containing a title, and optional description | `title`, `description`                                                           |
| [Warb::Components::Section](../components/section.md)        | Contains multiple rows, representing a section in the list                        | `title`, `rows` (array of `Warb::Components::Row`)                               |
| [Warb::Components::ListAction](../components/list_action.md) | Represents the action for the interactive list, containing sections and a button  | `button_text`, `sections` (array of `Warb::Components::Section`)                 |
