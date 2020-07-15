import 'package:flutter/material.dart';
import 'package:flutter_crud/providers/student_providers.dart';
import 'package:flutter_crud/screens/add.dart';
import 'package:flutter_crud/screens_child/student_info.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<StudentProviders>(context).fetchStudent().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    final studentData = Provider.of<StudentProviders>(context, listen: false);
    final _studentData = studentData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("AJAR CRUD API MYSQL"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Add.routeName);
              },
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _isLoading
                    ? Container(
                        height: _height * 0.85,
                        child: SpinKitDoubleBounce(
                          color: Colors.cyan,
                          size: 40.0,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          height: _height * 0.85,
                          child: _studentData.length == 0 ||
                                  _studentData.length == -1
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        'Belum ada data',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, right: 10, bottom: 10),
                                  itemCount: _studentData.length,
                                  itemBuilder: (context, index) =>
                                      ChangeNotifierProvider.value(
                                    value: _studentData[index],
                                    child: StudentInfo(),
                                  ),
                                ),
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
