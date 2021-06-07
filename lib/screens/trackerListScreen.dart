import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TrackerListScreen extends StatelessWidget {
  const TrackerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trackers List"),
        centerTitle: true,
      ),
      body: trackerList(),
    );
  }

  Widget trackerList() {
    return FutureBuilder(
        future: getTrackerList(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const Text(
                  "Long Press on List to Copy",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
                ),
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: snapshot.data));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copied to Clipboard"),
                    ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height - 148,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(snapshot.data.toString())),
                  ),
                ),
                InkWell(
                  child: const Text(
                    "Credits: ngosang",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.deepPurpleAccent),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        "https://github.com/ngosang/trackerslist")) {
                      await launch("https://github.com/ngosang/trackerslist");
                    } else {
                      throw "Could not launch";
                    }
                  },
                ),
              ],
            );
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
                  "Hold Tight - Getting Tracker List...",
                  style: TextStyle(
                    letterSpacing: 2.0,
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<String> getTrackerList() async {
    const String trackerListUrl =
        "https://ngosang.github.io/trackerslist/trackers_all.txt";
    const String trackerListUrlDns =
        "https://ngosang.github.io/trackerslist/trackers_all_ip.txt";
    String finalResponse = "";
    http.Response response = await http.get(Uri.parse(trackerListUrl));
    finalResponse += response.body;
    response = await http.get(Uri.parse(trackerListUrlDns));
    finalResponse += response.body;
    return finalResponse;
  }
}
