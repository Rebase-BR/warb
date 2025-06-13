# Location

The location dispatcher wrapper is used to send a location, such as a city or a point of interest.

It can include details like the name of the location, its coordinates (latitude and longitude), and an optional address.

To send a location, you can use the `dispatch` method of the `Warb.location` wrapper:
```ruby
Warb.location.dispatch(
  recipient_number,
  name: "Central Park",
  latitude: 40.785091,
  longitude: -73.968285,
  address: "New York, NY, USA"
)
```

You can also use the `dispatch` method with a block to set the location details:
```ruby
Warb.location.dispatch(recipient_number) do |location|
  location.name = "Eiffel Tower"
  location.latitude = 48.858844
  location.longitude = 2.294351
  location.address = "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"
end
```

Here is a breakdown of the parameters you can set for the location:
| Attribute  | Type     | Description                                  | Required |
|------------|----------|----------------------------------------------|----------|
| `name`     | `String` | The name of the location                     | No       |
| `latitude` | `Float`  | The latitude coordinate of the location      | Yes      |
| `longitude`| `Float`  | The longitude coordinate of the location     | Yes      |
| `address`  | `String` | The address of the location (optional)       | No       |