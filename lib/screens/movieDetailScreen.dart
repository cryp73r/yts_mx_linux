import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yts_mx_desktop/JsonData/getImageData.dart';
import 'package:yts_mx_desktop/JsonData/getJsonData.dart';
import 'package:yts_mx_desktop/screens/headerTabs.dart';
import 'package:yts_mx_desktop/utils/genreFixer.dart';
import 'package:yts_mx_desktop/utils/imageNameFixer.dart';
import 'package:yts_mx_desktop/utils/magnetLinkGenerator.dart';
import 'package:yts_mx_desktop/utils/utils.dart';

class MovieDetailScreen extends StatelessWidget {
  final int? movieId;

  const MovieDetailScreen({Key? key, @required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: headerTabs(context),
        actions: [
          searchButton(context),
        ],
      ),
      body: DisplayData(movieId: movieId),
    );
  }

  TextButton searchButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, "/searchScreen");
      },
      icon: const Icon(
        Icons.search,
        size: 30.0,
      ),
      label: Text(
        "Search",
        style: labelStyle(),
      ),
    );
  }

  TextStyle labelStyle() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    );
  }
}

class DisplayData extends StatelessWidget {
  final int? movieId;

  const DisplayData({Key? key, @required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJsonData(baseUrlMovieDetails, movie_id: movieId),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map? rawData = snapshot.data;
            return successResult(context, rawData);
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                ),
                const Text(
                  "Sit Back & Relax - Getting Details...",
                  style: TextStyle(
                    letterSpacing: 2.0,
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget successResult(BuildContext context, Map? rawData) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Stack(children: [
      SizedBox(
        height: _height,
        width: _width,
        child: Image.network(
          getImageData(
              imageNameFixer(rawData!["data"]["movie"]["slug"]), "background"),
          fit: BoxFit.fill,
          color: Colors.black87,
          colorBlendMode: BlendMode.darken,
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              child: child,
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
            );
          },
          errorBuilder:
              (BuildContext context, Object object, StackTrace? trace) {
            return Container(
              height: _height,
              width: _width,
              color: Colors.black,
            );
          },
        ),
      ),
      ListView(
        children: [
          coverNameYear(_height, _width, rawData),
          screenshotHolder(_height, _width),
          summaryHolder(rawData["data"]["movie"]["description_full"]),
        ],
      ),
    ]);
  }

  Widget coverNameYear(double _height, double _width, Map? rawData) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            height: _height * 0.5,
            width: _width * 0.19,
            decoration: BoxDecoration(
              border: Border.all(width: 4.0, color: Colors.white),
            ),
            child: Image.network(
              getImageData(imageNameFixer(rawData!["data"]["movie"]["slug"]),
                  "large-cover"),
              fit: BoxFit.fill,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  child: child,
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
              errorBuilder:
                  (BuildContext context, Object object, StackTrace? trace) {
                return SizedBox(
                  height: _height * 0.5,
                  width: _width * 0.19,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "images/logo-YTS.png",
                          fit: BoxFit.fill,
                        )),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0, left: 50.0),
            width: _width / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rawData["data"]["movie"]["title"],
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
                Text(
                  "\nYear: ${rawData["data"]["movie"]["year"]}",
                  style: const TextStyle(fontSize: 17.5, color: Colors.white60),
                ),
                Text(
                  "Genre: " +
                      genreFixer(rawData["data"]["movie"]["genres"]) +
                      "\n",
                  style: const TextStyle(fontSize: 17.5, color: Colors.white60),
                ),
                Wrap(
                    children: List.generate(
                        rawData["data"]["movie"]["torrents"].length, (index) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      child: Column(
                        children: [
                          Text(rawData["data"]["movie"]["torrents"][index]
                                  ["quality"] +
                              "." +
                              rawData["data"]["movie"]["torrents"][index]
                                      ["type"]
                                  .substring(0, 1)
                                  .toUpperCase() +
                              rawData["data"]["movie"]["torrents"][index]
                                      ["type"]
                                  .substring(1)),
                          Text(rawData["data"]["movie"]["torrents"][index]
                              ["size"]),
                        ],
                      ),
                      onPressed: () async {
                        String _magnetUrl = magnetLinkGenerator(
                            rawData["data"]["movie"]["torrents"][index]["hash"],
                            rawData["data"]["movie"]["title_long"],
                            rawData["data"]["movie"]["torrents"][index]
                                ["quality"],
                            rawData["data"]["movie"]["torrents"][index]["type"]
                                    .substring(0, 1)
                                    .toUpperCase() +
                                rawData["data"]["movie"]["torrents"][index]
                                        ["type"]
                                    .substring(1));
                        if (await canLaunch(_magnetUrl)) {
                          await launch(_magnetUrl);
                        } else {
                          throw "Could not launch";
                        }
                      },
                    ),
                  );
                })),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(4.0),
                          child: const Icon(
                            Icons.thumb_up,
                            color: Colors.white60,
                            size: 20.0,
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 4.0, right: 8.0),
                          child: Text(
                            "${rawData["data"]["movie"]["like_count"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white70),
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 8.0, right: 2.0),
                          child: const Icon(
                            Icons.download,
                            color: Colors.white60,
                            size: 20.0,
                          )),
                      Container(
                          margin: const EdgeInsets.fromLTRB(2.0, 4.0, 8.0, 4.0),
                          child: Text(
                            "${rawData["data"]["movie"]["download_count"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white70),
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 8.0, right: 4.0),
                          child: const Icon(
                            Icons.timer,
                            color: Colors.white60,
                            size: 20.0,
                          )),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                          child: Text(
                            "${rawData["data"]["movie"]["runtime"]} min",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white70),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 50.0),
              width: _width / 3,
              child: movieSuggestion(_height, _width)),
        ],
      ),
    );
  }

  Widget screenshotHolder(double _height, double _width) {
    return FutureBuilder(
        future: getJsonData(baseUrlMovieDetails,
            movie_id: movieId, with_images: true),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map? _tempData = snapshot.data;
            return Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Screenshots",
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  ),
                  SizedBox(
                    height: _height / 4,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.all(3.5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: _height / 4.2,
                                  width: _width / 3.3,
                                  child: Image.network(
                                    getImageData(
                                        imageNameFixer(_tempData!["data"]
                                            ["movie"]["slug"]),
                                        "medium-screenshot${index + 1}"),
                                    fit: BoxFit.fill,
                                    frameBuilder: (BuildContext context,
                                        Widget child,
                                        int? frame,
                                        bool wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) {
                                        return child;
                                      }
                                      return AnimatedOpacity(
                                        child: child,
                                        opacity: frame == null ? 0 : 1,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object object, StackTrace? trace) {
                                      return SizedBox(
                                        height: _height / 4.2,
                                        width: _width / 3.3,
                                        child: Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                "images/logo-YTS.png",
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const CupertinoActivityIndicator(
                  radius: 25.0,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                ),
                const Text(
                  "Relax - Loading Screenshots...",
                  style: TextStyle(
                    letterSpacing: 2.0,
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget summaryHolder(String synopsis) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Synopsis",
            style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w600),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
          ),
          Text(
            synopsis,
            style: const TextStyle(fontSize: 17.0, color: Colors.white70),
            textAlign: TextAlign.justify,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
        ],
      ),
    );
  }

  Widget movieSuggestion(double _height, double _width) {
    return FutureBuilder(
        future: getJsonData(baseUrlMovieSuggestions, movie_id: movieId),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map? _tempData = snapshot.data;
            return Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Similar Movies",
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  ),
                  SizedBox(
                    height: _height * 0.57,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _tempData!["data"]["movies"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: _width * 0.085,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3.0, color: Colors.white),
                                      ),
                                      child: Image.network(
                                        getImageData(
                                            imageNameFixer(_tempData["data"]
                                                ["movies"][index]["slug"]),
                                            "medium-cover"),
                                        fit: BoxFit.fill,
                                        frameBuilder: (BuildContext context,
                                            Widget child,
                                            int? frame,
                                            bool wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedOpacity(
                                            child: child,
                                            opacity: frame == null ? 0 : 1,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.easeOut,
                                          );
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object object, StackTrace? trace) {
                                          return Center(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "images/logo-YTS.png",
                                                  fit: BoxFit.fill,
                                                )),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _tempData["data"]["movies"][index]["title"]
                                                .length <=
                                            17
                                        ? _tempData["data"]["movies"][index]
                                            ["title"]
                                        : "${_tempData["data"]["movies"][index]["title"].substring(0, 18)}...",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${_tempData["data"]["movies"][index]["year"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(
                                            movieId: _tempData["data"]["movies"]
                                                [index]["id"],
                                          )));
                            },
                          );
                        }),
                  ),
                ],
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const CupertinoActivityIndicator(
                  radius: 25.0,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                ),
                const Text(
                  "Relax - Loading Similar Movies...",
                  style: TextStyle(
                    letterSpacing: 2.0,
                  ),
                )
              ],
            ),
          );
        });
  }
}
