import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static final jsonSchema = JsonSchema.fromMap({
    "\$schema": "http://json-schema.org/draft-07/schema",
    "\$id": "http://example.com/example.json",
    "type": "object",
    "title": "The root schema",
    "description": "The root schema comprises the entire JSON document.",
    "default": {},
    "examples": [
      {"name": "Casa 12", "propertyType": "House"}
    ],
    "required": ["name", "propertyType"],
    "properties": {
      "name": {
        "\$id": "#/properties/name",
        "type": "string",
        "title": "The name schema",
        "description": "An explanation about the purpose of this instance.",
        "default": "",
        "examples": ["Casa 12"]
      },
      "propertyType": {
        "\$id": "#/properties/propertyType",
        "default": "",
        "description": "An explanation about the purpose of this instance.",
        "examples": ["House"],
        "title": "The propertyType schema",
        "enum": ["House", "Apartment"],
        "type": "string"
      }
    }
  });

  static final editingControllerMapping =
      generateEditingControllerMapping(jsonSchema);
  final controller = FlutterJsonSchemaFormController(
    jsonSchema: jsonSchema,
    selectedFieldsCorrespondingToEnumFields: {"propertyType": "Apartment"},
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'JSON Schema Form',
          ),
        ),
        body: Center(
          child: Row(
            children: [
              Spacer(),
              Expanded(
                child: FlutterJsonSchemaForm.fromJsonSchema(
                  controller: controller,
                  jsonSchema: jsonSchema,
                  path: [],
                  onSubmit: () {
                    print(controller.data);
                  },
                  selectedFieldsCorrespondingToEnumFields: {
                    "propertyType": "Apartment",
                  },
                  onSelectedFieldOnEnumField: (selectedField) =>
                      print("Selected field on enum field: $selectedField"),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
