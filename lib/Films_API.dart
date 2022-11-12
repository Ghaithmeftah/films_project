// ignore_for_file: file_names

import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login.dart';
import '../classes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                    color: const Color.fromARGB(255, 253, 152, 0),
                  ),
                  const Text(
                    "Popular Films",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Color.fromARGB(255, 253, 152, 0)),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    icon: const Icon(Icons.logout),
                    color: const Color.fromARGB(255, 253, 152, 0),
                  ),
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
            const SizedBox(
              height: 25,
              child: Text(
                "Liked ones :",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 253, 152, 0)),
              ),
            ),
            SizedBox(
              height: 360,
              child: Builder(builder: (context) {
                // final listofResults = snapShot.data!;

                return BuildListOfFavorites();
              }),
            ),
          ]),
        )),
      ),
    );
  }
}

class BuildListOfFavorites extends StatefulWidget {
  // final List<Results> listoffavorites;
  // BuildListOfFavorites(this.listoffavorites, {Key? key}) : super(key: key);

  @override
  State<BuildListOfFavorites> createState() => _BuildListOfFavoritesState();
}

class _BuildListOfFavoritesState extends State<BuildListOfFavorites> {
  List<Results> _guestmoviefavorite = [];
  List<Results> get guestmoviefavorite => _guestmoviefavorite;

  Future<List<Results>> listoffavoritesFromFirebase() async {
    FirebaseFirestore.instance
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      // _guestmoviefavorite = [];
      for (final document in snapshot.docs) {
        _guestmoviefavorite.add(
          Results(
            title: document.data()['title'],
            favorite: document.data()['favorite'],
            adult: document.data()['adult'],
            backdropPath: document.data()['backdropPath'],
            genreIds: [1, 2, 3],
            id: document.data()['id'],
            originalLanguage: document.data()['originalLanguage'],
            originalTitle: document.data()['originalTitle'],
            overview: document.data()['overview'],
            popularity: document.data()['popularity'],
            posterPath: document.data()['posterPath'],
            releaseDate: document.data()['releaseDate'],
            video: false,
            voteCount: document.data()['voteCount'],
          ),
        );
      }
    });

    return _guestmoviefavorite;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listoffavoritesFromFirebase(),
        builder: (context, projectSnap) {
          if (!projectSnap.hasData) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(child: Text("no favorite films"));
          } else {
            print(
                "your list of favorite movies has ${_guestmoviefavorite.length} movies");
            return ListView.builder(
              itemCount: _guestmoviefavorite.length,
              itemBuilder: (context, index) {
                final result = _guestmoviefavorite[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://image.tmdb.org/t/p/original${result.posterPath!}"),
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
          }
        });
  }
}

// Widget buildimages(List<Results> listOfImages) => ListView.builder(
//       itemCount: listOfImages.length,
//       itemBuilder: (context, index) {
//         final result = listOfImages[index];
//         return Card(
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(
//                   "https://image.tmdb.org/t/p/original${result.posterPath!}"),
//             ),
//             title: Text(
//               "Title: ${result.originalTitle!}",
//               style: const TextStyle(
//                 color: Colors.black54,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 1,
//             ),
//             subtitle: Text(
//               "relesed in: ${result.releaseDate!}",
//               style: const TextStyle(
//                   color: Colors.black38,
//                   fontSize: 12.0,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       },
//     );

//create a list to stock the favorite movies
List<Results> bannersfavorites = [];

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

//il faux préciser le ID (généré automatique :( )) du Document ajoutée à travert la fct add du FirebaseFirestore
    FutureOr<void> AddFavoriteMovieToFirebase(Results R) {
      return FirebaseFirestore.instance
          .collection('favorites')
          .doc(R.title)
          .set(<String, dynamic>{
        'title': R.title,
        'favorite': true,
        'adult': R.adult,
        'genreIds': R.genreIds,
        'id': R.id,
        'originalLanguage': R.originalLanguage,
        'originalTitle': R.originalTitle,
        'overview': R.overview,
        'popularity': R.popularity,
        'posterPath': R.posterPath,
        'releaseDate': R.releaseDate,
        'video': R.video,
        'voteCount': R.voteCount,
      });
    }

    FutureOr<void> removeFavoriteMovieFromFirebase(String title) {
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(title)
          .delete()
          .then(
            (doc) => print("Document deleted"),
            onError: (e) => print("Error updating document $e"),
          );
    }

    Future overview(String? ch) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "overview:",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
          ),
          content: Text(
            "$ch",
            style: GoogleFonts.bitter(
              letterSpacing: .9,
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 207, 154, 93),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "ok",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                child: MaterialButton(
                  onPressed: (() =>
                      overview("${widget.listofresults[i].overview}")),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 220, top: 10, bottom: 220, left: 10),
                child: IconButton(
                    iconSize: 40,

                    //remplacer widget.listofresults[i].favorite! par l'attribut 'favorite' lit depuis firebase (à faire)
                    icon: Icon(widget.listofresults[i].favorite!
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline),
                    color: const Color.fromARGB(255, 253, 152, 0),
                    onPressed: () async {
                      setState(() {
                        widget.listofresults[i].favorite =
                            !widget.listofresults[i].favorite!;
                        //this (if) add the movie to firebase if the button favorite is clicked && add to bannersfavorite the favorite movies
                        if (widget.listofresults[i].favorite!) {
                          // bannersfavorites.add(widget.listofresults[i]);

                          AddFavoriteMovieToFirebase(widget.listofresults[i]);
                          // BuildListOfFavorites();
                        } else {
                          // bannersfavorites.removeWhere((element) =>
                          // element.title == widget.listofresults[i].title);

                          removeFavoriteMovieFromFirebase(
                              widget.listofresults[i].title!);
                          // BuildListOfFavorites();
                        }
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.listofresults[i].title}",
                      style: GoogleFonts.bitter(
                        letterSpacing: .7,
                        textStyle: const TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      "more than ${widget.listofresults[i].voteCount!} votes",
                      style: const TextStyle(
                          fontSize: 14.0,
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
