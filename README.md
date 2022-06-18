Create beautiful and low-effort forms that output valid data.
Based on Flutter / Material Design Widgets / JSON Schema.

## Features

<p>
  <img src="https://github.com/Instituto-Iracema/flutter_json_schema_form/blob/trunk/prints/formWithMaterial2Theme.png"
    alt="An image of a Material Design 2 form made with flutter_json_schema_form" height="400"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/Instituto-Iracema/flutter_json_schema_form/blob/trunk/prints/formWithMaterial3Theme.png"
   alt="An image of a Material Design 3 form made with flutter_json_schema_form" height="400"/>
</p>

- Render form UI from the provided JSON Schema
- Integrates with Flutter Material Themes
- Get programatically the form content as a JSON matching the provided JSON Schema
- Fill the form programatically
- ReadOnly fields
- Standard Fields
	- Object: forms inside forms
	- Enum: easy select option UI
	- String: get rid of boilerplate
	- Number: get rid of boilerplate²
- Special Fields
	- File fields: custom synthax for handling files

## Getting started
- Go to  [jsonschema.net](https://jsonschema.net) (or your favorite JSON Schema generation tool)
- Provide an example of JSON you want to match the JSON Schema
- Tools like jsonschema.net can provide a base JSON Schema you can easily customize and use with flutter_json_schema_form
- Start coding!
	- Guidance right below.

## Usage
Make the JSON Schema available on your app.
The simplest way to do this is to declare a variable of type `Map<String, dynamic>` and assign the key-value structure of the JSON Schema to it.

```dart
final jsonSchema = JsonSchema.fromMap({
    "\$schema": "https://json-schema.org/draft/2019-09/schema",
    "\$id": "http://example.com/example.json",
    "type": "object",
    "default": {},
    "title": "Clinic",
    "description":
        "A Clinic is where patients can have aesthetic sessions with their doctors.",
    "required": [
      "name",
      "cnpj",
    ],
    "properties": {
      "name": {
        "type": "string",
        "default": "",
        "title": "Name",
        "examples": ["Rosa Clínica"]
      },
      "cnpj": {
        "type": "string",
        "default": "",
        "title": "CNPJ",
        "description": "It is unique for each clinic.",
        "examples": ["05.768.725/0001-48"]
      }
    },
    "examples": [
      {
        "name": "Rosa Clínica",
        "cnpj": "05.768.725/0001-48"
      }
    ]
  });
```

Then, in your app, you can use the JSON Schema to render a form, like this:

```dart
class ClinicPageForm extends StatelessWidget {
  const ClinicPageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterJsonSchemaForm(
      jsonSchema: jsonSchema,
      buttonText: 'Send',
    );
  }
}

```

If you need a controller to handle the form, you can use the `FlutterJsonSchemaFormController` class:

```dart
class ClinicPageForm extends StatelessWidget {
  const ClinicPageForm({Key? key}) : super(key: key);

  final controller = FlutterJsonSchemaFormController(
        jsonSchema: jsonSchema,
      );

  @override
  Widget build(BuildContext context) {
    return FlutterJsonSchemaForm(
      jsonSchema: jsonSchema,
	  controller: controller,
      buttonText: 'Send',
    );
  }
}

```

## Additional information

- Check out the JSON Schema team's website: [JSON-Schema.org](https://json-schema.org/)
- Learn more about JSON Schema: [Understanding JSON Schema](https://json-schema.org/understanding-json-schema/)
- Your contribution to this package would be awesome! We will be happy to analyse your PR. You can use the GitHub repository issues for feature requesting, too.
- If you find any problem, make a GH issue and tell us about it!
- This package is proudly used and maintained by [Iracema Institute of Research and Innovation](https://github.com/Instituto-Iracema) Community. We will be happy to help you, reach out!