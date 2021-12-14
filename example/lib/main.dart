import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:json_schema_document/json_schema_document.dart';
import 'package:flutter_json_schema_form/controller/flutter_json_schema_form_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static final jsonSchema = JsonSchema.fromMap({
    "\$schema": "http://json-schema.org/draft-07/schema",
    "\$id": "http://example.com/example.json",
    "type": "object",
    "title": "Localidade Acessível",
    "maps_zoom": 3,
    "description":
        "Uma Localidade Acessível é capaz de assistir pessoas com deficiência visual através da infraestrutura BlindNavInd.",
    "examples": [
      {
        "title": "Shopping Benfica",
        "description":
            "É um dos Shoppings mais conhecidos da cidade. Apesar de pequeno, alguns consideram-o aconchegante.",
        "maps_zoom": 3,
        "coordinates": {
          "latitude": -3.741892778701611,
          "longitude": -38.53730096034952
        }
      }
    ],
    "required": ["title", "maps_zoom", "description", "coordinates"],
    "properties": {
      "svgProp": {
        "\$id": "#/properties/svgProps",
        "type": "object",
        "title": "I'm a file as an object with base64 data",
        "contentMediaType": "image/svg+xml",
        "writeOnly": true,
        "properties": {
          "name": {"type": "string"},
          "size": {"type": "number"},
          "type": {"type": "string"},
          "lastModified": {"type": "string", "format": "date-time"},
          "data": {"type": "string"}
        }
      },
      "title": {
        "\$id": "#/properties/title",
        "type": "string",
        "title": "Título",
        "description":
            "O título identifica a localidade como ela é chamada no dia a dia",
        "examples": ["Shopping Benfica"]
      },
      "description": {
        "\$id": "#/properties/description",
        "type": "string",
        "title": "Descrição",
        "description":
            "A descrição traz informações úteis e curiosidades sobre a localidade.",
        "examples": [
          "É um dos Shoppings mais conhecidos da cidade. Apesar de pequeno, alguns consideram-o aconchegante."
        ]
      },
      "maps_zoom": {
        "\$id": "#/properties/maps-zoom",
        "type": "number",
        "title": "maps_zoom",
        "description":
            "A descrição traz informações úteis e curiosidades sobre a localidade.",
        "examples": [3]
      },
      "coordinates": {
        "\$id": "#/properties/coordinates",
        "type": "object",
        "title": "Coordenadas Geográficas",
        "description":
            "Elas permitem a localização da localidade no mapa mundi.",
        "examples": [
          {"latitude": -3.741892778701611, "longitude": -38.53730096034952}
        ],
        "required": ["latitude", "longitude"],
        "properties": {
          "latitude": {
            "\$id": "#/properties/coordinates/properties/latitude",
            "type": "number",
            "title": "Latitude",
            "description":
                "A latitude é a distância ao Equador medida ao longo do meridiano de Greenwich. Esta distância mede-se em graus, podendo variar entre 0º e 90º para Norte(N) ou para Sul(S).",
            "examples": [-3.741892778701611]
          },
          "longitude": {
            "\$id": "#/properties/coordinates/properties/longitude",
            "type": "number",
            "title": "Longitude",
            "description":
                "A longitude é a distância ao meridiano de Greenwich medida ao longo do Equador.",
            "examples": [-38.53730096034952]
          }
        }
      }
    },
    "userInterface": {
      "flutter": {
        "preferredDisplay": "widgets:collection",
        "maps": {
          "childrenRepresentableAsMarkers": [
            "beacon",
            "pointOfInterest",
            "location"
          ]
        }
      },
      "material-ui": {
        "dataGrid": {
          "columns": [
            {"field": "nome", "headerName": "Nome", "flex": 2},
            {"field": "tipoUsuario", "headerName": "Tipo de Usuário", "flex": 1}
          ]
        }
      },
      "vuetify": {
        "dataTable": {
          "headers": [
            {"text": "Título", "align": "start", "value": "title"},
            {"text": "Descrição", "value": "description", "filterable": false},
            {
              "text": "Actions",
              "value": "actions",
              "align": "center",
              "sortable": false
            }
          ]
        },
        "preferredDisplay": "widgets:table"
      },
      "negociableAs": [
        "application/json+hal",
        "text/csv",
        "text/txt",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ]
    }
  });

  final editingControllerMapping = generateEditingControllerMapping(jsonSchema);
  final controller = FlutterJsonSchemaFormController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'JSON Schema Form',
          ),
        ),
        body: Center(
          child: Row(
            children: [
              Spacer(),
              Expanded(
                child: FlutterJsonSchemaForm.fromJsonSchema(
                  controller: controller,
                  jsonSchema: jsonSchema,
                  path: [],
                  editingControllerMapping: editingControllerMapping,
                  onSubmit: () {
                    final test = editingControllerMapping['title']
                        as TextEditingController;
                    test.value = TextEditingValue(text: 'teste');
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
