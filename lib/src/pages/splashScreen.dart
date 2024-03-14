import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/pages/core/homepage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2))
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Image(
          image: AssetImage("lib/Assets/itil.png"),
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
