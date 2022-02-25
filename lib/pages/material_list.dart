import 'package:flutter/material.dart';
import 'package:app/models/material_list.dart';
import 'package:flutter/rendering.dart';
import 'package:app/helpers/helper.dart';

class MaterialListPage extends StatelessWidget {
  final MaterialList materialList;
  MaterialListPage({Key key, this.materialList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materialList.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  child: ClipOval(
                    child: FadeInImage(
                      //image: NetworkImage(Helper.getUri('img/materialLists/' + materialList.picture).toString()),
                        image: AssetImage('assets/img/logo.png'),
                        placeholder: AssetImage('assets/img/logo.png')
                    ),
                  ),
                ),
              ),
              Text(
                '${materialList.code} x ${materialList.quantity.toStringAsFixed(4)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              Text(
                materialList.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(
                  'Almacen: ${materialList.warehouse}'
              ),
              Text(
                  'Tamaño de producción estandar: ${materialList.plannedAvgQuantity.toStringAsFixed(4)}'
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Etapa',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nº',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Cantidad',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Almacén',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: materialList.lines.map(
                        ((_line) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(_line.sequence.name, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_line.code, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_line.quantity.toStringAsFixed(4), style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_line.warehouse, style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        )),
                      ).toList()
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}