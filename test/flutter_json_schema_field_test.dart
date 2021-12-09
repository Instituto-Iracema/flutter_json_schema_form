import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';
import 'package:flutter_json_schema_form/widgets/flutter_json_schema_field.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';

void main() {
  // Should render title
  testWidgets(
    'Should render title',
    (WidgetTester tester) async {
      final jsonSchema = JsonSchema.fromMap(
        {
          "type": "string",
          "title": "Username",
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaFormField.fromJsonSchema(
              jsonSchema: jsonSchema,
              controller: FlutterJsonSchemaFormController(
                jsonSchema: jsonSchema,
              ),
              path: [],
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
      final jsonSchema = JsonSchema.fromMap(
        {
          "type": "number",
          "title": "Age",
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaFormField.fromJsonSchema(
              jsonSchema: jsonSchema,
              controller: FlutterJsonSchemaFormController(
                jsonSchema: jsonSchema,
              ),
              path: [],
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
      final jsonSchema = JsonSchema.fromMap(
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
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterJsonSchemaFormField.fromJsonSchema(
              jsonSchema: jsonSchema,
              controller: FlutterJsonSchemaFormController(
                jsonSchema: jsonSchema,
              ),
              path: [],
            ),
          ),
        ),
      );
      expect(find.byType(FlutterJsonSchemaForm), findsOneWidget);
    },
  );

  // TODO: Realocate this test to a more appropriate file, if any
  group('accessValue tests', () {
    test('Should be able to access non-nested fields', () {
      expect(accessValue(['a'], {'a': 'b'}) == 'b', true);
    });

    test('Should be able to access nested fields', () {
      expect(
        accessValue([
              'a',
              'b'
            ], {
              'a': {'b': 'c'}
            }) ==
            'c',
        true,
      );
    });
  });
}
