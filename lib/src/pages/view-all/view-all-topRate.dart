import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/pages/core/homepage.dart';
import 'package:Itil.Co/src/widgets/card-movie.dart';
import 'package:flutter/material.dart';

class ViewAllToprate extends StatefulWidget {
  final MovieTopRate data;
  const ViewAllToprate({super.key, required this.data});

  @override
  State<ViewAllToprate> createState() => _ViewAllToprateState();
}

class _ViewAllToprateState extends State<ViewAllToprate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: textCol2,
                          size: 18,
                        )),
                  ),
                  Text(
                    "Top Rate",
                    style: subHead1.copyWith(color: textCol2),
                  )
                ],
              ),
            )),
        backgroundColor: Color(0xff171717),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              itemCount: widget.data.results?.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 171,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                return CardMovie(
                    onTap: () {},
                    imgPoster:
                        "${Constants.imagePath}${widget.data.results?[index].posterPath}",
                    title: "${widget.data.results?[index].title}");
              },
            ),
            SizedBox(
              height: 14,
            )
          ],
        ),
      ),
    );
  }
}
