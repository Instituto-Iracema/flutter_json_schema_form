import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';

void main() {
  testWidgets(
    'Renders jsonSchema title correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaForm.fromJsonSchema(
              jsonSchema: JsonSchema.fromMap(
                {
                  "type": "object",
                  "title": "Login",
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
      expect(find.text('Login'), findsOneWidget);
    },
  );

  testWidgets('Renders jsonSchema description correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterJsonSchemaForm.fromJsonSchema(
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
    expect(find.text('Login to the system'), findsOneWidget);
  });
}
