library flutter_json_schema_form;

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';

/// A FormField generated from a JSON Schema property.
class FlutterJsonSchemaFormField extends StatelessWidget {
  const FlutterJsonSchemaFormField.fromJsonSchema({
    Key? key,
    required this.jsonSchema,
    required this.path,
    required this.controller,
    this.editingControllerMapping,
  }) : super(key: key);

  final JsonSchema jsonSchema;

  final FlutterJsonSchemaFormController controller;

  final Map<String, dynamic>? editingControllerMapping;

  final List<String> path;

  String? get title => jsonSchema.title;

  @override
  Widget build(BuildContext context) {
    switch (jsonSchema.type) {
      case JsonSchemaType.string:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              labelText: title,
            ),
            onChanged: (value) {
              controller.updateValue(path, value);
            },
            controller: accessValue(path, editingControllerMapping),
          ),
        );
      case JsonSchemaType.number:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              labelText: title,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.updateValue(path, value);
            },
            controller: accessValue(path, editingControllerMapping),
          ),
        );
      case JsonSchemaType.object:
        final svgProps = ['name', 'size', 'type', 'lastModified', 'data'];
        if (listEquals(svgProps, jsonSchema.properties.keys.toList())) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(controller.data['svgProp']?['name'] ??
                    'Importar arquivo'), // Currently not working
              ),
              IconButton(
                icon: const Icon(Icons.upload_file),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    final file = result.files.first;
                    final extension = file.extension;
                    if (extension == "svg") {
                      const type = "image/svg+xml";
                      final data = base64.encode(file.bytes ?? []);
                      final fileName = file.name;
                      final size = file.size;
                      final lastModified =
                          DateTime.now().toUtc().toIso8601String();
                      controller.data['svgProp'] = {
                        'name': fileName,
                        'size': size,
                        'type': type,
                        'lastModified': lastModified,
                        'data': data,
                      };
                    }
                  } else {
                    // User canceled the picker
                  }
                },
              )
            ],
          );
        } else {
          return Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: FlutterJsonSchemaForm.fromJsonSchema(
                  jsonSchema: jsonSchema,
                  isInnerField: true,
                  controller: controller,
                  path: path,
                  editingControllerMapping: editingControllerMapping,
                ),
              )
            ],
          );
        }
      default:
        return Container();
    }
  }
}

/// this function nests into the map following the path,
/// which is a list of each key to follow, finally, it returns the found value, or null if not found
dynamic accessValue(List<String> path, dynamic map) {
  if (path.isEmpty) {
    return map;
  }
  final String key = path.first;
  if (map is Map && map.containsKey(key)) {
    return accessValue(path.sublist(1), map[key]);
  } else {
    return map;
  }
}
