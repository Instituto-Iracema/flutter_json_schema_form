/// Create beautiful and low-effort forms that output valid data.
/// Based on Flutter / Material Design Widgets / JSON Schema.
library flutter_json_schema_form;

import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/widgets/flutter_json_schema_field.dart';
import 'package:json_schema_document/json_schema_document.dart';

import 'controller/flutter_json_schema_form_controller.dart';

/// A widget that displays a form based on a JSON Schema.
class FlutterJsonSchemaForm extends StatelessWidget {
  const FlutterJsonSchemaForm.fromJsonSchema({
    Key? key,
    required this.jsonSchema,
    this.isInnerField = false,
    required this.path,
    required this.controller,
    this.onSubmit,
    this.buttonText,
  }) : super(key: key);

  /// JSON Schema to use to generate the form.
  final JsonSchema jsonSchema;

  final bool isInnerField;

  final FlutterJsonSchemaFormController controller;

  final List<String> path;

  final String? buttonText;

  final Function? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (jsonSchema.title is String)
          Text(
            jsonSchema.title as String,
            style: isInnerField
                ? Theme.of(context).textTheme.headline6
                : Theme.of(context).textTheme.headline5,
          ),
        if (jsonSchema.description is String)
          Text(
            jsonSchema.description as String,
          ),
        const SizedBox(height: 16),
        if (jsonSchema.properties is Map)
          ...jsonSchema.properties.entries
              .map(
                (entry) => FlutterJsonSchemaFormField.fromJsonSchema(
                  jsonSchema: entry.value,
                  path: path.isEmpty ? [entry.key] : [...path, entry.key],
                  controller: controller,
                ),
              )
              .toList(),
        isInnerField
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (onSubmit != null) {
                        onSubmit!();
                      }
                    },
                    child: Text(buttonText ?? 'Submit'),
                  ),
                ],
              ),
      ],
    );
  }
}
