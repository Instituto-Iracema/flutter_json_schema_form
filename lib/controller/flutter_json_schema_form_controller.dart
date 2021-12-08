import 'package:flutter/widgets.dart';
import 'package:json_schema_document/json_schema_document.dart';

class FlutterJsonSchemaFormController {
  FlutterJsonSchemaFormController({this.textEditingControllerMapping});
  Map<String, dynamic> data = {};

  /// If null, the form inner state will be unaccessible.
  Map<String, dynamic>? textEditingControllerMapping = {};

  /// Create or update a value of the key on the specified path.
  void updateValue(List<String> path, String value) {
    print('value: $value // path: $path');

    String? updater = path.isNotEmpty ? path.last : null;

    // get the index of the last element
    int updaterIndex = path.length - 1;

    // print("updater is $updater. It's index is  $updaterIndex");

    if (updater != null) {
      // For each path element, we need to go one level deeper in the data map
      // and then update the value.
      var last = "0";

      for (var i = 0; i <= updaterIndex; i++) {
        final p = path[i];

        // case 0: the first element can be a value or a object
        if (i == 0) {
          // if this case is the last case, then we need to update the value
          if (updaterIndex == 0) {
            // update the value on the data field
            data[p] = value;
            // update or create the controller
            if (textEditingControllerMapping?[p] is TextEditingController) {
              (textEditingControllerMapping?[p] as TextEditingController).text =
                  value;
            } else if (textEditingControllerMapping?[p] == null) {
              textEditingControllerMapping?[p] =
                  TextEditingController(text: value);
            }

            // if this case isn't the last case, then we need to create de object
          } else {
            if (data[p] == null) {
              // create the object
              data[p] = {};
            }
            last = p;
          }
          // case 1: the second element only can be a value in this especific situation
        } else {
          data[last]?[p] = value;
          // update or create the controller
          if (textEditingControllerMapping?[last]?[p]
              is TextEditingController) {
            (textEditingControllerMapping?[last]?[p] as TextEditingController)
                .text = value;
          } else if (textEditingControllerMapping?[last]?[p] == null) {
            textEditingControllerMapping?[last]?[p] =
                TextEditingController(text: value);
          }
        }
      }
    }
  }

  /// Sets the value of both the instances of textEditingController on the
  /// textEditingControllerMapping map and the data map.
  void setData(Map<String, dynamic> newData) {
    // set the value on the data map
    data = newData;

    // recursively set the value on the textEditingControllerMapping map
    data.entries.forEach((entry) {
      textEditingControllerMapping?[entry.key]?.text = entry.value;
    });
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
