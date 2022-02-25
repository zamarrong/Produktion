import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/auth.dart';

class Login extends StatefulWidget {
  const Login({
    Key key,
  }) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage = '';

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false).login(_email, _password);
    if (result == false) {
      setState(() {
        _errorMessage = 'Usuario y/o contraseña incorrectos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 150,
                height: 150,
                child: FadeInImage(
                  //image: NetworkImage(Helper.getUri('img/items/' + item.picture).toString()),
                    image: AssetImage('assets/img/logo.png'),
                    placeholder: AssetImage('assets/img/logo.png')
                ),
              ),
            ),
            Text(
              'Produktion',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.w100
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Correo',
                  icon: Icon(
                    Icons.mail,
                  )
              ),
              validator: (value) => value.isEmpty ? 'Por favor ingresa un correo' : null,
              onSaved: (value) => _email = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Contraseña',
                icon: Icon(
                  Icons.lock,
                ),
              ),
              obscureText: true,
              validator: (value) => value.isEmpty ? 'Por favor ingresa una contraseña' : null,
              onSaved: (value) => _password = value,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: RaisedButton(
                elevation: 5.0,
                color: Colors.blue,
                child:  Text(
                  "Acceder",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    submitForm();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}