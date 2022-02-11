library flutter_json_schema_form;

import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';

/// A FormField generated from a JSON Schema property.
class FlutterJsonSchemaFormField extends StatelessWidget {
  const FlutterJsonSchemaFormField({
    Key? key,
    required this.jsonSchema,
    required this.path,
    required this.controller,
    this.forceDisabled = false,
    this.editingControllerMapping,
    this.fileWidget,
    this.formState = const {},
    this.onChanged,
    this.translateField = false,
    this.translateBase = '',
    this.fieldName = ''
  }) : super(key: key);

  final JsonSchema jsonSchema;

  final FlutterJsonSchemaFormController controller;

  final Map<String, dynamic>? editingControllerMapping;

  final List<String> path;

  final bool forceDisabled;

  final Widget? fileWidget;

  String? get title => jsonSchema.title ?? '';

  getTitleTranslation(context, key) {
    if (translateField) {
      var translateKey = jsonSchema.title != null ? jsonSchema.title.toString() : translateBase.isNotEmpty ? translateBase + '.properties.' + fieldName + '.title': '';
      return FlutterI18n.translate(context, translateKey);
    }
    return key;
  }

  bool get readOnly => forceDisabled ? true : jsonSchema.readOnly;

  bool get enabled => !readOnly;

  final Map<String, dynamic> formState;

  final Function(dynamic)? onChanged;

  final bool translateField;

  final String translateBase;

  final String fieldName;

  _onChanged(changeResult) {
    // field was selected at path
    // We should tell the higher level controller that we have selected a field
    final correspondingTextEditingController = accessValue(path, editingControllerMapping);
    if ((correspondingTextEditingController is TextEditingController) && (changeResult != null)) {
      correspondingTextEditingController.text = changeResult.toString();
      jsonSchema.default_ = null;
    }

    if (onChanged != null) {
      onChanged!(controller.data);
    }
  }

  _setValue(newValue) {
    final correspondingTextEditingController = accessValue(path, editingControllerMapping);
    if ((correspondingTextEditingController is TextEditingController) && (newValue != null)) {
      correspondingTextEditingController.text = newValue.toString();
    }
  }

  get _enumToSelectNumberItems => jsonSchema.enum_
      ?.map(
        (e) => DropdownMenuItem<num>(
          child: Text(e.toString()),
          value: e,
          onTap: () {},
        ),
      ).toList();

  get _enumToSelectItems => jsonSchema.enum_
      ?.map(
        (e) => DropdownMenuItem<String>(
          child:
            translateField && (num.tryParse(e.toString()) == null)
            ? I18nText(jsonSchema.title != null ? jsonSchema.title.toString() + '_enum.' + e.toString() : e.toString())
            : Text(e.toString()),
          value: e.toString(),
          onTap: () {},
        ),
      )
      .toList();

  Future<void> onUpload() async {
    final svgProp = controller.data['svgProp'];
    if (svgProp != null) {
      final newData = controller.data;
      newData['svgProp'] = null;
      controller.setData(newData);
      return;
    }
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
     var translatedTitle = getTitleTranslation(context, key);
     if (jsonSchema.default_ != null) {
       _setValue(jsonSchema.default_);
     }
     var fieldValue = accessValue(path, formState);
     var textController = accessValue(path, editingControllerMapping);
     switch (jsonSchema.type) {
      case JsonSchemaType.string:
        if (jsonSchema.enum_ != null) {
          return Row(
            children: [
              Text(translatedTitle),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: DropdownButton<String>(
                  value: fieldValue is String
                      ? fieldValue
                      : jsonSchema.default_,
                  onChanged: _onChanged,
                  items: _enumToSelectItems,
                ),
              ),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              labelText: translatedTitle
            ),
            onChanged: (value) {
              // controller.updateValue(path, value);
            },
            controller: textController,
            readOnly: readOnly,
            enabled: enabled,
          ),
        );
      case JsonSchemaType.number:
        if (jsonSchema.enum_ != null) {
          return Row(
            children: [
              Text(translatedTitle),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child:
                  DropdownButton<num>(
                    value: fieldValue is String
                        ? num.tryParse(fieldValue) ?? num.parse(fieldValue)
                        : jsonSchema.default_,
                    onChanged: _onChanged,
                    items: _enumToSelectNumberItems,
                  ),
          )
          ]);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              labelText: translatedTitle,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) {
              // controller.updateValue(path, value);
            },
            controller: textController,
            readOnly: readOnly,
            enabled: enabled,
          ),
        );
       case JsonSchemaType.boolean:
         return Row(
             children: [
               Text(translatedTitle),
               const SizedBox(width: 12),
               Padding(
                 padding: const EdgeInsets.all(4.0),
                 child: DropdownButton<bool>(
                   value: fieldValue is String
                       ? (fieldValue.toLowerCase() == 'true')
                       : jsonSchema.default_,
                   onChanged: _onChanged,
                   items: [
                     DropdownMenuItem<bool>(
                       child:
                          translateField
                          ? I18nText('template.options.true')
                          : const Text('true'),
                       value: true,
                       onTap: () {},
                     ),
                     DropdownMenuItem<bool>(
                       child:
                       translateField
                           ? I18nText('template.options.false')
                           : const Text('false'),
                       value: false,
                       onTap: () {},
                     ),
                   ],
                 ),
               )
             ]);
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
                child: FlutterJsonSchemaForm(
                  jsonSchema: jsonSchema,
                  isInnerField: true,
                  controller: controller,
                  path: path,
                  disabled: forceDisabled,
                  onChanged: onChanged,
                  formState: formState,
                  translate: translateField,
                  translateBase: translateBase != '' ? translateBase + '.' + fieldName : jsonSchema.title.toString()
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
