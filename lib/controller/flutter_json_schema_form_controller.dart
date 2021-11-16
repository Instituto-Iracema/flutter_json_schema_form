import 'package:flutter/widgets.dart';
import 'package:json_schema_document/json_schema_document.dart';

class FlutterJsonSchemaFormController {
  Map<String, dynamic> data = {};

  void updateValue(List<String> path, String value) {
    // For each path element, we need to go one level deeper in the data map
    // and then update the value.
    print('value: $value // path: $path');
  }
}
