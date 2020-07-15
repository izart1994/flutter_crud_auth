import 'package:flutter/material.dart';
import 'package:flutter_crud/models/student_model.dart';
import 'package:flutter_crud/providers/student_providers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rich_alert/rich_alert.dart';

class StudentEdit extends StatefulWidget {
  final String id;
  final String name;
  final String age;

  StudentEdit(
    this.id,
    this.name,
    this.age,
  );

  @override
  _StudentEditState createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  var _editedData = StudentModel(
    name: '',
    age: '',
  );

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    final studentId = widget.id;
    if (studentId != null) {
      try {
        await Provider.of<StudentProviders>(context).updateStudent(
          studentId,
          _editedData.name,
          _editedData.age,
        );
      } catch (error) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return RichAlertDialog(
              alertTitle: richTitle("Gagal"),
              alertSubtitle: richSubtitle("Masalah berlaku!"),
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
    }
    setState(() {
      _isLoading = false;
    });
    //Navigator.pop(context);
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kemaskini Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SpinKitDoubleBounce(
                    color: Colors.cyan[100],
                    size: 40.0,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: [
                      Form(
                        key: _form,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              initialValue: widget.name,
                              decoration: InputDecoration(labelText: 'Nama'),
                              textInputAction: TextInputAction.next,
                              focusNode: _nameFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Sila masukkan maklumat';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedData = StudentModel(
                                  name: value,
                                  age: _editedData.age,
                                );
                              },
                            ),
                            TextFormField(
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              initialValue: widget.age,
                              decoration: InputDecoration(labelText: 'Umur'),
                              textInputAction: TextInputAction.next,
                              focusNode: _ageFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Sila masukkan maklumat';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedData = StudentModel(
                                  name: _editedData.name,
                                  age: value,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              _saveForm();
                            },
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: Colors.cyan,
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
