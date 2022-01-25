import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:json_schema_document/json_schema_document.dart';

class FlutterJsonSchemaFormController {
  FlutterJsonSchemaFormController({
    required this.jsonSchema,
  }) {
    textEditingControllerMapping = generateEditingControllerMapping(jsonSchema);
  }
  // Map<String, dynamic> data = {};
  Map<String, dynamic>? initialState = {};
  Function(Map<String, dynamic>)? onChanged;

  /// If null, the form inner state will be unaccessible.
  Map<String, dynamic> textEditingControllerMapping = {};

  JsonSchema jsonSchema;

  List<PlatformFile> files = [];

  Map<String, dynamic> get data => computeData();

  Map<String, dynamic> computeData([Map<String, dynamic>? data]) {
    if (files.isNotEmpty) {
      // Picks the first file.
      final file = files.first;
      setData({
        "svgProp": {
          "type": "image/svg+xml",
          "size": file.size.toString(),
          "data": base64.encode(file.bytes ?? []),
          "lastModified": DateTime.now().toUtc().toIso8601String(),
          "name": file.name,
        }
      });
    }

    // get the data to work on
    final actualData = data ?? textEditingControllerMapping;

    return actualData.map((key, value) {
      if (value is TextEditingController) {
        // If the value is empty, we should nullify it
        return value.text.isNotEmpty
            ? MapEntry(key, value.text)
            : MapEntry(key, null);
      } else if (value is Map<String, dynamic>) {
        // If the value is a map, we should recursively call this function
        return MapEntry(key, computeData(value));
      }
      // Ideally, we should never reach this point
      return MapEntry(key, "isso não deve acontecer");
    })
      // Where the value is null, we remove it
      ..removeWhere((key, value) => value == null)
      // Where the the value is a map, we remove it if it is empty
      ..removeWhere(
        (key, value) => value is Map ? value.isEmpty : false,
      );
  }

  void addFile(PlatformFile file) {
    files.add(file);
  }

  /// Sets the value of both the instances of textEditingController on the
  /// textEditingControllerMapping map and the data map.
  void setData(Map<String, dynamic> newData,
      [Map<String, dynamic>? newTextEditingControllerMapping]) {
    // final listOfKeys = newData.keys.toList();

    // if (newTextEditingControllerMapping == null) {
    //   newTextEditingControllerMapping = textEditingControllerMapping;
    //   data = newData;
    // }

    newTextEditingControllerMapping ??= textEditingControllerMapping;

    // newTextEditingControllerMapping ??= textEditingControllerMapping;

    // For each key in the newData map
    for (final key in newData.keys) {
      // if the values of the corresponding key in the newData map and the newTextEditingControllerMapping are Maps
      if (newTextEditingControllerMapping[key] is Map && newData[key] is Map) {
        // then we call setData recursively, passing the maps as parameters
        setData(newData[key], newTextEditingControllerMapping[key]);
      }
      // else, the values should be a String for newData and a TextEditingController for newTextEditingControllerMapping
      else {
        // we update the text of the controller found on newTextEditingControllerMapping?[key].text
        // with the value of the corresponding key in the newData map
        (newTextEditingControllerMapping[key] as TextEditingController).text =
            newData[key];
      }
    }
  }
}

/// Takes as an argument a [JsonSchema] and return a Map<String, dynamic> where
/// the keys are the names of the properties and the values are instances of
/// [TextEditingController] for the corresponding properties on the
/// FlutterJSONSchemaForm or similar maps on recursive fashion
Map<String, dynamic> generateEditingControllerMapping(JsonSchema jsonSchema) {
  // for each property on the JSON Schema
  return jsonSchema.properties.map((key, value) {
    // if the property is an object
    if (value.type == JsonSchemaType.object) {
      // if the property is an object, then we need to create a map with the
      // same name and the same type of the object
      return MapEntry(key, generateEditingControllerMapping(value));
    } else {
      // if the property is a value, then we need to create a controller
      return MapEntry(key, TextEditingController());
    }
  });
}
