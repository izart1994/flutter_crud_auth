import 'package:flutter/material.dart';
import 'package:flutter_crud/models/student_model.dart';
import 'package:flutter_crud/providers/student_providers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rich_alert/rich_alert.dart';

class Add extends StatefulWidget {
  static const routeName = '/add';
  Add({Key key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _state;
  String _detail;
  var _isLoading = false;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();

  final _nameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();

  var _addStudent = StudentModel(
    id: null,
    name: '',
    age: '',
  );

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<StudentProviders>(context, listen: false)
          .addStudent(_addStudent);

      final addStudent = Provider.of<StudentProviders>(context);
      setState(() {
        _state = addStudent.state;
        _detail = addStudent.detail;
        if (_state == "Successful") {
          _alert(
            "Berjaya",
            _detail,
            RichAlertType.SUCCESS,
          );
          _nameController.clear();
          _ageController.clear();
        } else {
          _alert(
            "Tidak Berjaya",
            _detail,
            RichAlertType.ERROR,
          );
        }
      });
    } catch (error) {
      await _alert(
        "Tidak Berjaya",
        "Masalah berlaku. Sila isi semula.",
        RichAlertType.ERROR,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  _alert(title, subtitle, alertType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          alertTitle: richTitle(title),
          alertSubtitle: richSubtitle(subtitle),
          alertType: alertType,
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.cyan,
              child: Text(
                "Okay",
                style: TextStyle(
                  color: Colors.white,
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
    final _addData = Text(
      'Tambah Data',
      style: TextStyle(
        fontSize: 24,
      ),
      textAlign: TextAlign.center,
    );

    final _name = TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nama',
        labelStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Colors.black45,
          ),
        ),
      ),
      style: TextStyle(color: Colors.black45),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Sila Masukkan Nama';
        }
        return null;
      },
      onSaved: (value) {
        _addStudent = StudentModel(
          name: value,
          age: _addStudent.age,
        );
      },
    );

    final _age = TextFormField(
      controller: _ageController,
      decoration: InputDecoration(
        labelText: 'Umur',
        labelStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Colors.black45,
          ),
        ),
      ),
      style: TextStyle(color: Colors.black45),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_ageFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Sila Masukkan Umur';
        }
        return null;
      },
      onSaved: (value) {
        _addStudent = StudentModel(
          name: _addStudent.name,
          age: value,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("AJAR CRUD API MYSQL"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
              child: Icon(
                Icons.list,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
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
                    _addData,
                    SizedBox(height: 8.0),
                    _name,
                    SizedBox(height: 8.0),
                    _age,
                    SizedBox(height: 8.0),
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
                              onPressed: _saveForm,
                              padding: EdgeInsets.all(12),
                              color: Colors.blue,
                              child: Text(
                                'Tambah',
                                style: TextStyle(color: Colors.white),
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
