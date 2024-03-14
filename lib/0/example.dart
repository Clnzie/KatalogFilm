import 'dart:io';

import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late FToast fToast;
  int exitCounter = 0;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        exitCounter++;
        exitCounter = exitCounter;
        if (exitCounter == 1) {
          return _popUpExit();
        } else if (exitCounter == 2) {
          return exit(0);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _popUpExit();
                  },
                  child: Text("Toast"))
            ],
          ),
        ),
      ),
    );
  }

  _popUpExit() {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
          color: textCol2, borderRadius: BorderRadius.circular(12)),
      child: Text(
        "Press again to exit",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      fadeDuration: Duration(milliseconds: 250),
      toastDuration: Duration(seconds: 2),
    );
  }
}
