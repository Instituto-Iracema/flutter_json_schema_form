import 'package:flutter/widgets.dart';
import 'package:json_schema_document/json_schema_document.dart';

class FlutterJsonSchemaFormController {
  Map<String, dynamic> data = {};

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
            data[p] = value;
            // if this case isn't the last case, then we need to create de object
          } else {
            if (data[p] == null) {
              data[p] = {};
            }
            last = p;
          }
          // case 1: the second element only can be a value in this especific situation
        } else {
          data[last][p] = value;
        }
      }
    }
  }
}
