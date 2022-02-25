import 'package:app/models/item_serial_number.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SerialNumbersAlertDialogWidget extends StatefulWidget {
  final List<ItemSerialNumber> serialsNumbers;
  SerialNumbersAlertDialogWidget({Key key, this.serialsNumbers}) : super(key: key);

  @override
  _SerialNumbersAlertDialogWidgetState createState() => _SerialNumbersAlertDialogWidgetState();
}

class _SerialNumbersAlertDialogWidgetState extends StateMVC<SerialNumbersAlertDialogWidget> {
  FocusNode serialNumberFocusNode;
  final serialNumberController = TextEditingController();
  bool _validate = true;

  Future<void> scanner(BuildContext context) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode("#db322a", "Cancelar", true, ScanMode.BARCODE);
    _selectSerialNumber(barcode);
  }

  void _selectSerialNumber(String serial) {
    setState(() {
      try {

        ItemSerialNumber serialNumber = widget.serialsNumbers.firstWhere((element) => element.serial == serial);
        if (serialNumber != null) {
          serialNumber.selected = true;
        }
        serialNumberController.clear();

        _validate = true;
      } catch (e) {
        _validate = false;
      } finally {
        FocusScope.of(context).requestFocus(serialNumberFocusNode);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selección de números de serie'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            TextField(
              controller: serialNumberController,
              focusNode: serialNumberFocusNode,
              decoration: InputDecoration(
                hintText: 'Ingresa el número de serie',
                errorText: _validate ? null : 'Número de serie no encontrado',
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () => scanner(context),
                ),
              ),
              onSubmitted: (serial) { _selectSerialNumber(serial); },
            ),
            DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Selección',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Artículo',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Número de serie',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: widget.serialsNumbers.map(
                (_serial) => DataRow(
                  cells: <DataCell>[
                    DataCell(Checkbox(
                      activeColor: Colors.green,
                      onChanged: (bool checked) {
                        setState(() {
                          _serial.selected = checked;
                        });
                      },
                      value: _serial.selected,
                    )),
                    DataCell(Text(_serial.itemCode)),
                    DataCell(Text(_serial.serial)),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.green,
          icon: Icon(Icons.done),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        )
      ],
    );
  }
}