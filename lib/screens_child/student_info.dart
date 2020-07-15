import 'package:flutter/material.dart';
import 'package:flutter_crud/models/student_model.dart';
import 'package:flutter_crud/providers/student_providers.dart';
import 'package:flutter_crud/screens_child/student_edit.dart';
import 'package:provider/provider.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({Key key}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    final studentData = Provider.of<StudentModel>(context, listen: false);
    String _id = studentData.id;
    String _name = studentData.name;
    String _age = studentData.age;

    void deleteInfo() {
      AlertDialog alertDialog = new AlertDialog(
        content: new Text("Anda pasti mahu memadamkan '$_name' dari senarai?"),
        actions: <Widget>[
          new RaisedButton(
            child: new Text(
              "OK! PADAM",
              style: new TextStyle(color: Colors.black),
            ),
            color: Colors.red,
            onPressed: () {
              Provider.of<StudentProviders>(context).deleteStudent(
                _id,
              );
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          new RaisedButton(
            child: new Text(
              "BATAL",
              style: new TextStyle(
                color: Colors.black,
              ),
            ),
            color: Colors.green,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );

      showDialog(context: context, child: alertDialog);
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: _height * 0.15,
          padding: EdgeInsets.only(left: 10, top: 10, right: 5, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: _width / 1.7,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            _name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _height / 39,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          width: _width / 1.7,
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            _age,
                            style: TextStyle(
                              fontSize: _height / 45,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //editInfo();
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StudentEdit(_id, _name, _age),
                          ),
                        );
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteInfo();
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
