import 'package:app/models/item.dart';
import 'package:app/models/item_batch_number.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class BatchNumbersAlertDialogWidget extends StatefulWidget {
  final Item item;
  final List<ItemBatchNumber> batchsNumbers;
  final double quantity;
  BatchNumbersAlertDialogWidget({Key key, this.item, this.quantity, this.batchsNumbers}) : super(key: key);

  @override
  _BatchNumbersAlertDialogWidgetState createState() => _BatchNumbersAlertDialogWidgetState();
}

class _BatchNumbersAlertDialogWidgetState extends StateMVC<BatchNumbersAlertDialogWidget> {
  FocusNode batchNumberFocusNode;
  final batchNumberController = TextEditingController();
  bool _validate = true;

  Future<void> scanner(BuildContext context) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode("#db322a", "Cancelar", true, ScanMode.BARCODE);
    _selectBatchNumber(barcode);
  }

  void _selectBatchNumber(String batch) {
    setState(() {
      try {
        ItemBatchNumber batchNumber = widget.batchsNumbers.firstWhere((element) => element.batchNum == batch);
        if (batchNumber != null) {
          batchNumber.selected = true;
        }
        batchNumberController.clear();

        _validate = true;
      } catch (e) {
        _validate = false;
      } finally {
        FocusScope.of(context).requestFocus(batchNumberFocusNode);
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
      title: Text('Selección de lotes para: ${widget.item.name} (${widget.item.code})'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Text(
              'Cantidad requerida: ${widget.quantity}'
            ),
            TextField(
              controller: batchNumberController,
              focusNode: batchNumberFocusNode,
              decoration: InputDecoration(
                hintText: 'Ingresa el número de lote',
                errorText: _validate ? null : 'Número de lote no encontrado',
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () => scanner(context),
                ),
              ),
              onSubmitted: (serial) { _selectBatchNumber(serial); },
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Selección',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Lote',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Almacén',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cant. Almacén',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cantidad',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: widget.batchsNumbers.map(
                          (_batch) => DataRow(
                        cells: <DataCell>[
                          DataCell(Checkbox(
                            activeColor: Colors.blue,
                            onChanged: (bool checked) {
                              setState(() {
                                _batch.selected = checked;
                              });
                            },
                            value: _batch.selected,
                          )),
                          DataCell(Text(_batch.batchNum)),
                          DataCell(Text(_batch.whsCode)),
                          DataCell(Text(_batch.whsQuantity.toStringAsFixed(4))),
                          DataCell(
                            TextField(
                              controller: TextEditingController()..text = (_batch.quantity > 0) ? _batch.quantity.toStringAsFixed(4) : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.grey,
                                  filled: !_batch.selected
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                setState(() {
                                  _batch.quantity = double.parse(value);
                                  _batch.selected = (_batch.quantity > 0) ? true : false;
                                });
                              },
                            ),
                          ),
                        ],
                      )).toList(),
                ),
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