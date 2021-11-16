import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'JSON Schema Form',
          ),
        ),
        body: Center(
          child: FlutterJsonSchemaForm.fromJsonSchema(
            jsonSchema: JsonSchema.fromMap(
              {
                "type": "object",
                "title": "Login",
                "description": "Login to the system",
                "properties": {
                  "username": {"type": "string", "title": "Username"},
                  "password": {"type": "string", "title": "Password"}
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
