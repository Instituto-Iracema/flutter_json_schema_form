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
            body: FlutterJsonSchemaForm.fromJsonSchema(
              jsonSchema: JsonSchema.fromMap(
                {
                  "type": "object",
                  "title": "Login",
                },
              ),
            ),
          ),
        ),
      );
      expect(find.text('Login'), findsOneWidget);
    },
  );

  // Should render description
  testWidgets('Should render description', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterJsonSchemaForm.fromJsonSchema(
            jsonSchema: JsonSchema.fromMap(
              {
                "type": "object",
                "title": "Login",
                "description": "Login to the system",
              },
            ),
          ),
        ),
      ),
    );
    expect(find.text('Login to the system'), findsOneWidget);
  });

  // Should render properties as TextFields

  group('Should render properties as TextFields', () {
    testWidgets(
        'With two properties should render two FlutterJsonSchemaFormField',
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
                    "username": {
                      "type": "string",
                      "title": "Username",
                    },
                    "password": {
                      "type": "string",
                      "title": "Password",
                    },
                  },
                },
              ),
            ),
          ),
        ),
      );
      expect(find.byType(FlutterJsonSchemaFormField), findsNWidgets(2));
    });
  });
}
