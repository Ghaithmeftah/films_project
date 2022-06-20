import 'dart:convert';

import '../classes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Films API Project',
      home: FilmsAPI(),
    );
  }
}

class FilmsAPI extends StatefulWidget {
  const FilmsAPI({Key? key}) : super(key: key);

  @override
  State<FilmsAPI> createState() => _FilmsAPIState();
}

class _FilmsAPIState extends State<FilmsAPI> {
  //load your json data from the assets
  late Future<List<Results>?> listofResults;

  @override
  void initState() {
    super.initState();
    listofResults = getResults(context);
  }

  Future<List<Results>?> getResults(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('jsonFile/data.json');

    final body = json.decode(data);
    return Images.fromJson(body).results;
  }

  @override
  Widget build(BuildContext context) {
    var scrennheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: scrennheight,
        width: screenwidth,
        child: SafeArea(
            child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                  const Text(
                    "Popular Films",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
                ],
              ),
            ),
            SizedBox(
              height: 320,
              child: FutureBuilder<List<Results>?>(
                  future: getResults(context),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapShot.hasError) {
                      return Text(" :( $snapShot.error");
                    } else if (snapShot.hasData) {
                      final listofresults = snapShot.data!;
                      return BannerWidgetArea(listofresults);
                    } else {
                      return const Text("No Image URL found");
                    }
                  }),
            ),
            SizedBox(
              height: 420,
              child: FutureBuilder<List<Results>?>(
                  future: getResults(context),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapShot.hasError) {
                      return Text(" :( $snapShot.error");
                    } else if (snapShot.hasData) {
                      final listofresults = snapShot.data!;
                      return buildimages(listofresults);
                    } else {
                      return const Text("No Image URL found");
                    }
                  }),
            ),
          ]),
        )),
      ),
    );
  }
}

Widget buildimages(List<Results> listOfImages) => ListView.builder(
      itemCount: listOfImages.length,
      itemBuilder: (context, index) {
        final result = listOfImages[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://image.tmdb.org/t/p/original${result.backdropPath!}"),
            ),
            title: Text(
              "Title: ${result.originalTitle!}",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            subtitle: Text(
              "relesed in: ${result.releaseDate!}",
              style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );

// var bannerItems = ["Lord of The Ring", "Avengers", "the Flash", "the pioniste"];
// var bannerImages = [
//   "images/th.webp",
//   "images/The-Avengers-650ff76d.webp",
//   "images/The-Flash-Cropped.webp",
//   "images/The-pianist.webp"
// ];

class BannerWidgetArea extends StatefulWidget {
  final List<Results> listofresults;
  const BannerWidgetArea(this.listofresults, {Key? key}) : super(key: key);

  @override
  State<BannerWidgetArea> createState() => _BannerWidgetAreaState();
}

class _BannerWidgetAreaState extends State<BannerWidgetArea> {
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    PageController controller =
        PageController(viewportFraction: 0.8, initialPage: 1);
    List<Widget> banners = <Widget>[];

    for (int i = 0; i < widget.listofresults.length; i++) {
      var bannerView = Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ]),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                child: Image.network(
                  "https://image.tmdb.org/t/p/original${widget.listofresults[i].backdropPath!}",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black])),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.listofresults[i].originalTitle}",
                      style: const TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "more than ${widget.listofresults[i].voteCount!} votes",
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }
    return SizedBox(
      height: screenheight * 9 / 26,
      width: screenwidth,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: banners,
      ),
    );
  }
}
