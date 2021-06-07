import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yts_mx_desktop/JsonData/getImageData.dart';
import 'package:yts_mx_desktop/JsonData/getJsonData.dart';
import 'package:yts_mx_desktop/screens/movieDetailScreen.dart';
import 'package:yts_mx_desktop/utils/imageNameFixer.dart';
import 'package:yts_mx_desktop/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = "";
  List _rawData = [];
  int _maxLimit = 0;
  int? _pageNumber;
  bool _searching = false;
  bool _displayWheel = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.98) {
        _pageNumber = _pageNumber! + 1;
        if (_pageNumber! * 20 <= _maxLimit) {
          _getMoreData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No more Movies related to search."),
          ));
          setState(() {
            _displayWheel = false;
          });
        }
      }
    });
    super.initState();
  }

  _getMoreData() async {
    Map tempData = await getJsonData(baseUrlListMovies,
        page: _pageNumber, query_term: _query);
    _rawData.addAll(tempData["data"]["movies"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 80,
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20.0, color: Colors.white70),
              decoration: const InputDecoration(
                  hintText: "Be Precise, Like: Interstellar",
                  hintStyle: TextStyle(color: Colors.white54),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
              autocorrect: false,
              textInputAction: TextInputAction.search,
              onChanged: (String queryTerm) {
                _query = queryTerm;
                _pageNumber = 1;
                _rawData.clear();
                _searching = true;
                if (queryTerm == "") {
                  _searching = false;
                }
                if (_maxLimit <= 6) {
                  _displayWheel = false;
                }
                setState(() {});
              },
            ),
          ),
        ),
      ]),
      body: _searching ? searchResult(context) : notSearching(context),
      // drawer: appDrawer(context),
    );
  }

  Widget notSearching(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "App starts searching each time you enter 1 Character.",
              style: bodyStyle(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
            ),
            Text(
              "Be very Precise with search to save time.",
              style: bodyStyle(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
            ),
            Text(
              "Like: 'Inter' won't show any result,",
              style: bodyStyle(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
            ),
            Text(
              "but 'Interstellar' will show.",
              style: bodyStyle(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
            ),
            Text(
              "After typing new character,",
              style: bodyStyle(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
            ),
            Text(
              "if results are not shown in 5-8s,",
              style: bodyStyle(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
            ),
            Text(
              "type new Character.",
              style: bodyStyle(),
            )
          ],
        ),
      ),
    );
  }

  TextStyle bodyStyle() {
    return const TextStyle(
      fontSize: 16.0,
      color: Colors.white38,
      fontWeight: FontWeight.w400,
    );
  }

  Widget searchResult(BuildContext context) {
    return FutureBuilder(
        future: getJsonData(baseUrlListMovies, query_term: _query),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map? tempData = snapshot.data;
            _maxLimit = tempData!["data"]["movie_count"];
            if (_maxLimit > 0) {
              if (_pageNumber == 1) {
                _rawData = tempData["data"]["movies"];
              }
              return successResult(context);
            }
          }
          return Center(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  ),
                  const Text(
                    "Searching...",
                    style: TextStyle(
                      letterSpacing: 2.0,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget successResult(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemCount: _rawData.length + 1,
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == _rawData.length) {
            return _displayWheel
                ? const CupertinoActivityIndicator(
                    radius: 20.0,
                  )
                : const Text("");
          }
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: _height * 0.01),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: _height * 0.3,
                      width: _width * 0.13,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.0, color: Colors.white),
                      ),
                      child: Image.network(
                        getImageData(imageNameFixer(_rawData[index]["slug"]),
                            "medium-cover"),
                        fit: BoxFit.fill,
                        frameBuilder: (BuildContext context, Widget child,
                            int? frame, bool wasSynchronouslyLoaded) {
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
                        errorBuilder: (BuildContext context, Object object,
                            StackTrace? trace) {
                          return SizedBox(
                            height: _height * 0.3,
                            width: _width * 0.13,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/logo-YTS.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    _rawData[index]["title"].length <= 17
                        ? _rawData[index]["title"]
                        : "${_rawData[index]["title"].substring(0, 18)}...",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_rawData[index]["year"]}",
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
                            movieId: _rawData[index]["id"],
                          )));
            },
          );
        },
      ),
    );
  }
}
