/// Create beautiful and low-effort forms that output valid data.
/// Based on Flutter / Material Design Widgets / JSON Schema.
library flutter_json_schema_form;

import 'package:flutter/material.dart';
import 'package:json_schema_document/json_schema_document.dart';
import 'package:tuple/tuple.dart';

/// A widget that displays a form based on a JSON Schema.
class FlutterJsonSchemaForm extends StatelessWidget {
  const FlutterJsonSchemaForm.fromJsonSchema({
    Key? key,
    required this.jsonSchema,
  }) : super(key: key);

  /// JSON Schema to use to generate the form.
  final JsonSchema jsonSchema;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(jsonSchema.title as String));
  }
}

Tuple2<TextEditingController, Widget> inputAndControllerTupleFromJsonSchema(
    JsonSchema jsonSchema) {
  return Tuple2(
    TextEditingController(),
    const TextField(),
  );
}
