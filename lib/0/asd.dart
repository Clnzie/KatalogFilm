import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieDetailModelApi.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Asd extends StatefulWidget {
  final String movieId;
  const Asd({super.key, required this.movieId});

  @override
  State<Asd> createState() => _AsdState();
}

class _AsdState extends State<Asd> {
  final HttpService httpService = HttpService();

  Future getData() async {
    await httpService.getDetailMovie(widget.movieId);
  }

  late Future dataAPi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataAPi = getData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: httpService.getDetailMovie(widget.movieId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Column(
                children: [
                  Text(snapshot.data?.title ?? ''),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.genres?.length,
                    itemBuilder: (context, index) {
                      return Text(snapshot.data!.genres?[index].name ?? '');
                    },
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
