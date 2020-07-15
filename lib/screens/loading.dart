import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 15,
      fontFamily: 'Ubuntu',
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: Colors.cyan[100],
      body: Center(
        child: Text(
          'Sila tunggu sekejap...',
          style: textStyle,
        ),
      ),
    );
  }
}
