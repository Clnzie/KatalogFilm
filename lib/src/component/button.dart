import 'package:Itil.Co/src/Utils/color.dart';
import 'package:flutter/material.dart';

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: textCol1,
  foregroundColor: Colors.white,
  minimumSize: const Size(60, 53),
  padding: const EdgeInsets.symmetric(horizontal: 26),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7)),
  ),
);
