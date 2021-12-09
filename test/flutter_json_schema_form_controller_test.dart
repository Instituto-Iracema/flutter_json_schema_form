import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_document/json_schema_document.dart';

void main() {
  group('updateValue method tests', () {
    // Should create or update value of the key on the specified path - nesting of level 1
    test(
        'Should create or update value of the key on the specified path - nesting of level 1',
        () {
      final controller = FlutterJsonSchemaFormController(
        jsonSchema: JsonSchema.fromMap({}),
      );
      controller.updateValue(['test'], 'testValue');
      expect(controller.data['test'], 'testValue');
      controller.updateValue(['test'], 'testValue2');
      expect(controller.data['test'], 'testValue2');
    });

    // Should create or update value of the key on the specified path on the corresponding controller - nesting of level 1
    test(
        'Should create or update value of the key on the specified path on the corresponding controller - nesting of level 1',
        () {});

    // Should create or update value of the key on the specified path - nesting of level 2
    test(
        'Should create or update value of the key on the specified path - nesting of 2 levels',
        () {
      final controller = FlutterJsonSchemaFormController(
        jsonSchema: JsonSchema.fromMap({}),
      );
      controller.updateValue(['coordinates', 'latitude'], '-23.5');
      expect(controller.data['coordinates']?['latitude'], '-23.5');
    });

    // Should create or update value of the key on the specified path on the corresponding controller - nesting of level 2
    test(
        'Should create or update value of the key on the specified path on the corresponding controller - nesting of level 1',
        () {});

    // Should create or update value of the key on the specified path - nesting of level 3
    // test(
    //     'Should create or update value of the key on the specified path - nesting of 3 levels',
    //     () {
    //   final controller = FlutterJsonSchemaFormController();
    //   controller.updateValue(['coordinates', 'latitude', 'decimal'], '-23.5');
    //   expect(controller.data['coordinates']?['latitude']?['decimal'], '-23.5');
    // });
  });

  // generateEditingControllerMapping tests
  group('generateEditingControllerMapping tests', () {
    // Should generate surface level mapping on non-nested jsonSchema
    test('Should generate surface level mapping on non-nested jsonSchema', () {
      final controllerMapping =
          generateEditingControllerMapping(JsonSchema.fromMap({
        "type": "object",
        "title": "Login",
        "properties": {
          "username": {
            "type": "string",
            "title": "Username",
          },
          "password": {
            "type": "string",
            "title": "Password",
          },
        },
      }));
      expect(controllerMapping['username'] is TextEditingController, true);
    });

    // Should generate corresponding map on nested jsonSchema - level 1
    test('Should generate corresponding map on nested jsonSchema  - level 1',
        () {
      final controllerMapping =
          generateEditingControllerMapping(JsonSchema.fromMap({
        "type": "object",
        "title": "Login",
        "properties": {
          "coordinates": {
            "type": "object",
            "title": "Coordinates",
            "properties": {
              "latitude": {
                "type": "number",
                "title": "Latitude",
              },
              "longitude": {
                "type": "number",
                "title": "Longitude",
              },
            },
          },
        },
      }));
      expect(controllerMapping['coordinates'] is Map, true);
      expect(
          controllerMapping['coordinates']?['latitude']
              is TextEditingController,
          true);
      expect(
          controllerMapping['coordinates']?['longitude']
              is TextEditingController,
          true);
    });
  });

  // Should generate corresponding map on nested jsonSchema - level 2
  test('Should generate corresponding map on nested jsonSchema - level 2', () {
    final controllerMapping =
        generateEditingControllerMapping(JsonSchema.fromMap({
      "type": "object",
      "title": "Login",
      "properties": {
        "coordinates": {
          "type": "object",
          "title": "Coordinates",
          "properties": {
            "latitude": {
              "type": "object",
              "title": "Latitude",
              "properties": {
                "decimal": {
                  "type": "number",
                  "title": "Decimal",
                },
                "degrees": {
                  "type": "number",
                  "title": "Degrees",
                },
                "minutes": {
                  "type": "number",
                  "title": "Minutes",
                },
                "seconds": {
                  "type": "number",
                  "title": "Seconds",
                },
              },
            },
            "longitude": {
              "type": "object",
              "title": "Longitude",
              "properties": {
                "decimal": {
                  "type": "number",
                  "title": "Decimal",
                },
                "degrees": {
                  "type": "number",
                  "title": "Degrees",
                },
                "minutes": {
                  "type": "number",
                  "title": "Minutes",
                },
                "seconds": {
                  "type": "number",
                  "title": "Seconds",
                },
              },
            },
          },
        },
      },
    }));
    expect(controllerMapping['coordinates'] is Map, true);
    expect(controllerMapping['coordinates']?['latitude'] is Map, true);
    expect(
        controllerMapping['coordinates']?['latitude']?['decimal']
            is TextEditingController,
        true);
    expect(controllerMapping['coordinates']?['longitude'] is Map, true);
    expect(
        controllerMapping['coordinates']?['longitude']?['decimal']
            is TextEditingController,
        true);
  });

  // setValue should update a shallow map
  group('setValue tests', () {
    test('setValue should update a shallow map', () {
      final controller = FlutterJsonSchemaFormController(
        jsonSchema: JsonSchema.fromMap(
          {
            "type": "object",
            "title": "Login",
            "properties": {
              "username": {
                "type": "string",
                "title": "Username",
              },
              "password": {
                "type": "string",
                "title": "Password",
              },
            },
          },
        ),
      );
      controller.setData({
        'username': 'Elias',
        'password': '123',
      });
      expect(controller.data['username'], 'Elias');
    });

    test('setValue should update a nested map - level 1', () {
      final jsonSchema = JsonSchema.fromMap(
        {
          "type": "object",
          "title": "Login",
          "properties": {
            "coordinates": {
              "type": "object",
              "title": "Coordinates",
              "properties": {
                "latitude": {
                  "type": "number",
                  "title": "Latitude",
                },
                "longitude": {
                  "type": "number",
                  "title": "Longitude",
                },
              },
            },
          },
        },
      );

      final controller =
          FlutterJsonSchemaFormController(jsonSchema: jsonSchema);
      controller.setData({
        'coordinates': {
          'latitude': '-23.5',
          'longitude': '-45.6',
        }
      });

      expect(controller.data['coordinates']?['latitude'], '-23.5');
      expect(controller.data['coordinates']?['longitude'], '-45.6');
    });
  });
}
