import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final TextStyleApp _textStyleApp = TextStyleApp();
  final ColorApp _colorApp = ColorApp();

  final ImageProvider<Object> img;
  final String title, subTitle;
  CustomTile(
      {super.key,
      required this.img,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 39, 38, 38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: img,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              height: 120,
              width: 80,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    _textStyleApp.subHead2.copyWith(color: _colorApp.textCol2),
              ),
              Text(
                subTitle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                maxLines: 5,
                style: _textStyleApp.textL.copyWith(color: _colorApp.textCol2),
              )
            ],
          )
        ],
      ),
    );
  }
}
