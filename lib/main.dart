// import 'package:Itil.Co/0/example.dart';
import 'package:Itil.Co/0/example.dart';
import 'package:Itil.Co/src/pages/core/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: "Movie.Co",
      home: HomePage(),
    );
  }
}
