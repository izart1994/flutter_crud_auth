import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rich_alert/rich_alert.dart';

import '../providers/user_providers.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  String _token;

  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    // Log user in
    await Provider.of<AuthProviders>(context, listen: false).authenticate(
      _authData['username'],
      _authData['password'],
    );

    final authData = Provider.of<AuthProviders>(context, listen: false);
    _token = authData.token;

    if (_token == null) {
      setState(() {
        _isLoading = false;
      });
      return _alert();
    }
  }

  _alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          alertTitle: richTitle("Gagal"),
          alertSubtitle:
              richSubtitle("Nama Pengguna dan Kata Laluan tidak sepadan!"),
          alertType: RichAlertType.ERROR,
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.cyan,
              child: Text(
                "Okay",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final _username = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Nama Pengguna',
        labelStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value.isEmpty) {
          return 'Nama Pengguna Tak Sah!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['username'] = value;
      },
    );

    final _password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Kata Laluan',
        labelStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      controller: _passwordController,
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value.isEmpty || value.length < 5) {
          return 'Kata Laluan Terlalu Pendek!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value;
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    _username,
                    SizedBox(height: 8.0),
                    _password,
                    SizedBox(height: 24.0),
                    _isLoading
                        ? SpinKitDoubleBounce(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            size: 40.0,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: _submit,
                              padding: EdgeInsets.all(12),
                              color: Colors.cyan,
                              child: Text(
                                'Log Masuk',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
