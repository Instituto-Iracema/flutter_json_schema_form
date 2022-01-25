/// Create beautiful and low-effort forms that output valid data.
/// Based on Flutter / Material Design Widgets / JSON Schema.
library flutter_json_schema_form;

import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/widgets/flutter_json_schema_field.dart';
import 'package:json_schema_document/json_schema_document.dart';

import 'controller/flutter_json_schema_form_controller.dart';

/// A widget that displays a form based on a JSON Schema.
class FlutterJsonSchemaForm extends StatelessWidget {
  const FlutterJsonSchemaForm({
    Key? key,
    required this.jsonSchema,
    required this.controller,
    this.buttonText,
    this.fileWidget,
    this.onSubmit,
    this.onChanged,
    this.isInnerField = false,
    this.disabled = false,
    this.path = const [],
    this.formState = const {},
  }) : super(key: key);

  /// JSON Schema to use to generate the form.
  final JsonSchema jsonSchema;

  final bool isInnerField;

  /// Controller to use to manage the form.
  final FlutterJsonSchemaFormController controller;

  /// List of keys that must be followed to find this form on a nested form. \
  /// For the root form on an nested form structure, it is usually an empty list.
  final List<String> path;

  final String? buttonText;

  /// Callback to execute when the form is submitted.
  final Function? onSubmit;

  /// Callback to execute when the form is changed. \
  /// This callback should call *state management* methods.
  final Function(dynamic)? onChanged;

  /// When to disable the form input.
  final bool disabled;

  /// Widget to use to input a file
  final Widget? fileWidget;

  /// Current state of the form.
  final Map<String, dynamic> formState;

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
                (entry) => FlutterJsonSchemaFormField(
                  fileWidget: fileWidget,
                  forceDisabled: disabled,
                  jsonSchema: entry.value,
                  path: path.isEmpty ? [entry.key] : [...path, entry.key],
                  controller: controller,
                  editingControllerMapping:
                      controller.textEditingControllerMapping,
                  formState: formState,
                  onChanged: onChanged,
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
