import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yts_mx_desktop/JsonData/getJsonData.dart';
import 'package:yts_mx_desktop/utils/utils.dart';

class UpdateAppScreen extends StatelessWidget {
  const UpdateAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getJsonData(updateUrl),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              Map? rawData = snapshot.data;
              return successWidget(context, rawData);
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
                    "Checking for Updates...",
                    style: TextStyle(
                      letterSpacing: 2.0,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget successWidget(BuildContext context, Map? rawData) {
    return Column(
      children: [
        Flexible(
            child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          children: [
            Image.asset(
              "images/logo-YTS.png",
              width: 120.0,
              height: 120.0,
            ),
            Center(
                child: appVer == rawData!["data"][0]["version"]
                    ? Text(
                        "No Updates Available",
                        style: updateStyle(),
                      )
                    : Text(
                        "New Update Available",
                        style: updateStyle(),
                      )),
            Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            ),
            Center(
                child: appVer == rawData["data"][0]["version"]
                    ? Text(
                        "Current Version: $appVer",
                        style: newVerStyle(),
                      )
                    : Text(
                        "New App Version: " + rawData["data"][0]["version"],
                        style: newVerStyle(),
                      )),
            Container(
              margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            ),
            Center(
                child: appVer == rawData["data"][0]["version"]
                    ? const Text("")
                    : Text(
                        "Release Date: ${DateFormat.yMMMMd('en_US').format(DateTime(int.parse(rawData["data"][0]["release_date"].substring(0, 4)), int.parse(rawData["data"][0]["release_date"].substring(5, 7)), int.parse(rawData["data"][0]["release_date"].substring(8, 10))))}",
                        style: newVerStyle(),
                      )),
            Container(
              margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            ),
            Center(
                child: appVer == rawData["data"][0]["version"]
                    ? const Text("")
                    : Text(
                        "Current Version: " + appVer,
                        style: curVerStyle(),
                      )),
          ],
        )),
        appVer == rawData["data"][0]["version"]
            ? const Text("")
            : Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 15.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                            onPressed: () async {
                              String _sourceUrl =
                                  "https://yts.pythonanywhere.com" +
                                      rawData["data"][0]["url"];
                              if (await canLaunch(_sourceUrl)) {
                                await launch(_sourceUrl);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                            child: Text(
                              "Download Now (" +
                                  rawData["data"][0]["size"] +
                                  ")",
                              style: const TextStyle(fontSize: 17.0),
                            )),
                      )
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  TextStyle updateStyle() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      letterSpacing: 4.0,
    );
  }

  TextStyle newVerStyle() {
    return const TextStyle(
      fontSize: 15.0,
      color: Colors.white60,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle curVerStyle() {
    return const TextStyle(
      fontSize: 15.0,
      color: Colors.white54,
      fontWeight: FontWeight.w300,
    );
  }
}
