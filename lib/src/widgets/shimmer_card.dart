import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  final ColorApp _colorApp = ColorApp();
  ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: _colorApp.baseColShimmer,
          highlightColor: _colorApp.highlightColShimmer,
          child: Container(
            height: 163,
            width: 110,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(15)),
          ),
        ),
        SizedBox(
          height: 9,
        ),
        Shimmer.fromColors(
          baseColor: _colorApp.baseColShimmer,
          highlightColor: _colorApp.highlightColShimmer,
          child: Container(
            width: double.infinity,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(50)),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Shimmer.fromColors(
          baseColor: _colorApp.baseColShimmer,
          highlightColor: _colorApp.highlightColShimmer,
          child: Container(
            width: 70,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ],
    );
  }
}
