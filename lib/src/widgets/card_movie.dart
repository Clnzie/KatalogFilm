import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardMovie extends StatelessWidget {
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();

  final Function() onTap;
  final String imgPoster, title;
  CardMovie(
      {super.key,
      required this.onTap,
      required this.imgPoster,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgPoster,
      filterQuality: FilterQuality.high,
      imageBuilder: (context, imageProvider) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 115,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // color: Color(0xff3a3a3a),
                  color: Colors.transparent,
                  image: DecorationImage(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.fill,
                      image: NetworkImage(imgPoster))),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 115,
              height: 171,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      colors: [Color(0xff000000), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center)),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _textStyleApp.textXL.copyWith(
                          color: _colorApp.textCol2,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: _colorApp.baseColShimmer,
        highlightColor: _colorApp.highlightColShimmer,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 115,
          // height: 171,
          decoration: BoxDecoration(
              color: Color(0xff3a3a3a),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error_outline_rounded,
        color: Colors.red,
        size: 24,
      ),
    );
  }
}

   

    // Container(
    //       margin: EdgeInsets.symmetric(horizontal: 4),
    //       width: 115,
    //       height: 171,
    //       decoration: BoxDecoration(
    //           image: DecorationImage(image: imageProvider),
    //           borderRadius: BorderRadius.circular(15),
    //           gradient: LinearGradient(
    //               colors: [Color(0xff000000), Color.fromARGB(0, 0, 0, 0)],
    //               begin: Alignment.bottomCenter,
    //               end: Alignment.center)),
    //       child: InkWell(
    //         onTap: onTap,
    //         borderRadius: BorderRadius.circular(15),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
    //           child: Align(
    //             alignment: Alignment.bottomLeft,
    //             child: Text(
    //               title,
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //               style: textXL.copyWith(
    //                   color: textCol2,
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 13),
    //             ),
    //           ),
    //         ),
    //       ),
    //     )