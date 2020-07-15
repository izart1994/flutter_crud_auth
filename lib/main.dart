import 'package:flutter/material.dart';
import 'package:flutter_crud/providers/student_providers.dart';
import 'package:flutter_crud/providers/user_providers.dart';
import 'package:flutter_crud/screens/add.dart';
import 'package:flutter_crud/screens/home.dart';
import 'package:flutter_crud/screens/loading.dart';
import 'package:flutter_crud/screens/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProviders(),
        ),
        ChangeNotifierProvider.value(
          value: StudentProviders(),
        ),
      ],
      child: Consumer<AuthProviders>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'AJAR CRUD API MYSQL',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.tryAutoSignin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.active
                          ? Loading()
                          : Login(),
                ),
          routes: {
            Add.routeName: (context) => Add(),
          },
        ),
      ),
    );
  }
}
