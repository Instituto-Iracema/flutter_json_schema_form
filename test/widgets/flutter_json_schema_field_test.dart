import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/widgets/flutter_json_schema_field.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';

void main() {
  // Should render title
  testWidgets(
    'Should render title',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaFormField.fromJsonSchema(
              jsonSchema: JsonSchema.fromMap(
                {
                  "type": "string",
                  "title": "Username",
                },
              ),
            ),
          ),
        ),
      );
      expect(find.text('Username'), findsOneWidget);
    },
  );

  // Should TextField if type is 'number'
  testWidgets(
    "Should TextField if type is 'number",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaFormField.fromJsonSchema(
              jsonSchema: JsonSchema.fromMap(
                {
                  "type": "number",
                  "title": "Age",
                },
              ),
            ),
          ),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    },
  );

  // Should render an recursive form if the schema's type is 'object'
  testWidgets(
    "Should render an recursive form if the schema's type is 'object'",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaFormField.fromJsonSchema(
              jsonSchema: JsonSchema.fromMap(
                {
                  "type": "object",
                  "title": "User",
                  "properties": {
                    "name": {
                      "type": "string",
                      "title": "Name",
                    },
                    "age": {
                      "type": "integer",
                      "title": "Age",
                    },
                  },
                },
              ),
            ),
          ),
        ),
      );
      expect(find.byType(FlutterJsonSchemaForm), findsOneWidget);
    },
  );
}
