import 'package:flutter/material.dart';
import 'package:mobilerollcall/auth.dart';
import 'package:mobilerollcall/routes.dart';

void main() => runApp(new MobileRollCallApp());

class MobileRollCallApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Mobile Roll Call Flutter App',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }


}