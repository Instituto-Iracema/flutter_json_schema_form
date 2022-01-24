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
    this.forceDisabled = false,
    this.editingControllerMapping,
    this.fileWidget,
    this.selectedFieldsCorrespondingToEnumFields = const {},
    this.onSelectedFieldOnEnumField,
  }) : super(key: key);

  final JsonSchema jsonSchema;

  final FlutterJsonSchemaFormController controller;

  final Map<String, dynamic>? editingControllerMapping;

  final List<String> path;

  final bool forceDisabled;

  final Widget? fileWidget;

  String? get title => jsonSchema.title;

  bool get readOnly => forceDisabled ? true : jsonSchema.readOnly;

  bool get enabled => !readOnly;

  final Map<String, dynamic> selectedFieldsCorrespondingToEnumFields;

  final Function(dynamic, dynamic)? onSelectedFieldOnEnumField;

  Future<void> onUpload() async {
    // print(controller.data['svgProp']);
    final svgProp = controller.data['svgProp'];
    if (svgProp != null) {
      final newData = controller.data;
      newData['svgProp'] = null;
      controller.setData(newData);
      return;
    }
    // print(controller.data[pa])
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.first;
      final extension = file.extension;
      if (extension == "svg") {
        controller.addFile(file);
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (jsonSchema.type) {
      case JsonSchemaType.string:
        if (jsonSchema.enum_ != null) {
          return DropdownButton<String>(
            value: accessValue(
              path,
              selectedFieldsCorrespondingToEnumFields,
            ) is String
                ? accessValue(
                    path,
                    selectedFieldsCorrespondingToEnumFields,
                  )
                : null,
            onChanged: (changeResult) {
              // field was selected at path
              // We should tell the higher level controller that we have selected a field

              final correspondingTextEditingController =
                  accessValue(path, editingControllerMapping);

              print(
                  "correspondingTextEditingController: $correspondingTextEditingController");

              if (correspondingTextEditingController is TextEditingController) {
                correspondingTextEditingController.text = changeResult ?? "";
              }

              if (onSelectedFieldOnEnumField != null) {
                onSelectedFieldOnEnumField!(path, changeResult);
              }
            },
            items: jsonSchema.enum_
                ?.map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e),
                    value: e as String,
                    onTap: () {},
                  ),
                )
                .toList(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              labelText: title,
            ),
            onChanged: (value) {
              // controller.updateValue(path, value);
            },
            controller: accessValue(path, editingControllerMapping),
            readOnly: readOnly,
            enabled: enabled,
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
              // controller.updateValue(path, value);
            },
            controller: accessValue(path, editingControllerMapping),
            readOnly: readOnly,
            enabled: enabled,
          ),
        );
      case JsonSchemaType.object:
        final svgProps = ['name', 'size', 'type', 'lastModified', 'data'];
        if (listEquals(svgProps, jsonSchema.properties.keys.toList())) {
          return fileWidget ?? Container();
          // return Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(bottom: 8.0),
          //         child: Text(
          //           title ?? 'File',
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       Row(
          //         children: [
          //           ElevatedButton(
          //               onPressed: forceDisabled ? null : onUpload,
          //               child: Row(children: [
          //                 controller.data['svgProp'] == null
          //                     ? Icon(Icons.file_upload)
          //                     : Icon(Icons.delete),
          //                 controller.data['svgProp'] == null
          //                     ? Text('Importar')
          //                     : Text('Remover'),
          //               ])),
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(controller.data['svgProp']?['name'] ??
          //                 'Nenhum arquivo'),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // );
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
                  disabled: forceDisabled,
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
