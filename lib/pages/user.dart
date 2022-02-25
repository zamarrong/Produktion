import 'dart:convert';

import 'package:app/controllers/user_controller.dart';
import 'package:app/repository/user_repository.dart';
import 'package:app/widgets/CircularLoadingWidget.dart';
import 'package:checkbox_formfield/checkbox_list_tile_formfield.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  final int id;

  UserPage({Key key, this.id}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends StateMVC<UserPage> {
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  UserController _con;

  _UserPageState() : super(UserController()) {
    _con = controller;
  }

  void _showDoneAlertDialog() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: Text('Usuario'),
            content: Text('¿Esta seguro de guardar este usuario?'),
            actions: <Widget>[
              IconButton(
                color: Colors.red,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
              IconButton(
                color: Colors.green,
                icon: Icon(Icons.done_all),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  addOrUpdateUser(_con.user).then((value) {
                    if (value is http.Response) {
                      setState(() {
                        if (value.statusCode == 201 || value.statusCode == 200) {
                          Scaffold.of(_formKey.currentContext).showSnackBar(SnackBar(
                            content: Text("Operación realizada correctamente",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ));
                        } else {
                          Scaffold.of(_formKey.currentContext).showSnackBar(SnackBar(
                            content: Text("Ocurrió un error al realizar la operación",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                          ));
                        }
                      });
                    }
                  });
                },
              )
            ],
          );
      }
    );
  }

  @override
  void initState() {
    _con.listenForUser(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        title: Text('Usuario'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _showDoneAlertDialog();
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshUser,
        child: _con.loading ? CircularLoadingWidget(height: 500) :
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _con.user.name,
                  decoration: InputDecoration(
                      hintText: 'Nombre',
                      icon: Icon(
                        Icons.person,
                      )
                  ),
                  validator: (value) => value.isEmpty ? 'Por favor ingresa un nombre' : null,
                  onSaved: (value) => _con.user.name = value,
                ),
                TextFormField(
                  initialValue: _con.user.email,
                  decoration: InputDecoration(
                      hintText: 'Correo',
                      icon: Icon(
                        Icons.mail,
                      )
                  ),
                  validator: (value) => value.isEmpty ? 'Por favor ingresa un correo' : null,
                  onSaved: (value) => _con.user.email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    icon: Icon(
                      Icons.lock,
                    ),
                  ),
                  obscureText: true,
                  onSaved: (value) => _con.user.password = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Administrador'),
                  initialValue: _con.user.admin,
                  onSaved: (bool value) => _con.user.admin = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Reporte de terminación'),
                  initialValue: _con.user.terminationReport,
                  onSaved: (bool value) => _con.user.terminationReport = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Entrega componentes'),
                  initialValue: _con.user.genEntry,
                  onSaved: (bool value) => _con.user.genEntry = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Entrada subproductos'),
                  initialValue: _con.user.genExit,
                  onSaved: (bool value) => _con.user.genExit = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Transferencia de stock'),
                  initialValue: _con.user.stockTransfer,
                  onSaved: (bool value) => _con.user.stockTransfer = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Solicitud de transferencia'),
                  initialValue: _con.user.stockTransferRequest,
                  onSaved: (bool value) => _con.user.stockTransferRequest = value,
                ),
                CheckboxListTileFormField(
                  title: Text('Lista de materiales'),
                  initialValue: _con.user.materialList,
                  onSaved: (bool value) => _con.user.materialList = value,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}