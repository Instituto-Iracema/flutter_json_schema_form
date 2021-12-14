import 'package:flutter/widgets.dart';
import 'package:json_schema_document/json_schema_document.dart';

class FlutterJsonSchemaFormController {
  FlutterJsonSchemaFormController({required this.jsonSchema}) {
    textEditingControllerMapping = generateEditingControllerMapping(jsonSchema);
  }
  // Map<String, dynamic> data = {};
  Map<String, dynamic>? initialState = {};
  Function(Map<String, dynamic>)? onChanged;

  /// If null, the form inner state will be unaccessible.
  Map<String, dynamic> textEditingControllerMapping = {};

  JsonSchema jsonSchema;

  Map<String, dynamic> get data => computeData();

  Map<String, dynamic> computeData([Map<String, dynamic>? data]) {
    // get the data to work on
    final actualData = data ?? textEditingControllerMapping;

    return actualData.map((key, value) {
      if (value is TextEditingController) {
        return value.text.isNotEmpty
            ? MapEntry(key, value.text)
            : MapEntry(key, null);
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, computeData(value));
      }
      return MapEntry(key, "isso não deve acontecer");
    })
      ..removeWhere((key, value) => value == null)
      ..removeWhere(
        (key, value) => value is Map ? value.isEmpty : false,
      );
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

    // for (final entry in newData.entries) {
    //   final correspondingValueOnTextEditingControllerMapping =
    //       textEditingControllerMapping?[entry.key];
    //   if (correspondingValueOnTextEditingControllerMapping
    //       is TextEditingController) {
    //     correspondingValueOnTextEditingControllerMapping.text = entry.value;
    //   }
    //   if (correspondingValueOnTextEditingControllerMapping is Map) {
    //     setData(newData[entry.key] as Map<String, dynamic>);
    //   }
    // }
  }

//   void setTextEditingControllers(Map<String, dynamic> newData) {
//     // recursively set the value on the textEditingControllerMapping map
//     for (var entry in data.entries) {
//       // if the value is a map, then we need to recursively set the value on the
//       // ...
//       if (entry.value is Map &&
//           textEditingControllerMapping?[entry.key] is Map) {
//         setTextEditingControllers(entry.value);
//       }
//       // else, we need to set the value on the textEditingControllerMapping map
//       else {
//         (textEditingControllerMapping?[entry.key] as TextEditingController?)
//             ?.text = entry.value;
//       }
//     }
//   }
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
