import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';

void main() {
  runApp(MyAppWithState());
}

class MyAppWithState extends StatefulWidget {
  const MyAppWithState({Key? key}) : super(key: key);

  @override
  _MyAppWithStateState createState() => _MyAppWithStateState();
}

class _MyAppWithStateState extends State<MyAppWithState> {
  Map<String, dynamic> formState = {
    "propertyType": "Apartment",
  };

  static final editingControllerMapping =
      generateEditingControllerMapping(jsonSchema);
  final controller = FlutterJsonSchemaFormController(
    jsonSchema: jsonSchema,
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
                child: FlutterJsonSchemaForm(
                  controller: controller,
                  jsonSchema: jsonSchema,
                  formState: formState,
                  onSubmit: () {
                    print(controller.data);
                  },
                  onChanged: (newFormState) {
                    setState(() {
                      formState = newFormState;
                    });
                  },
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

final jsonSchema = JsonSchema.fromMap({
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
    "propertyType1": {
      "\$id": "#/properties/propertyType",
      "default": "",
      "description": "An explanation about the purpose of this instance.",
      "examples": ["House"],
      "title": "The propertyType schema",
      "enum": ["House", "Apartment", "Flat", "Townhouse"],
      "type": "string"
    },
    "embedded": {
      "type": "object",
      "title": "The embedded schema",
      "description": "An explanation about the purpose of this instance.",
      "default": {},
      "properties": {
        "propertyType2": {
          "\$id": "#/properties/embedded/properties/propertyType",
          "default": "",
          "description": "An explanation about the purpose of this instance.",
          "examples": ["House"],
          "title": "The propertyType schema",
          "enum": ["House", "Apartment", "Flat", "Townhouse"],
          "type": "string"
        },
      },
    }
  }
});
