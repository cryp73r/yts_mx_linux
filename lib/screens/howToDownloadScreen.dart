import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToDownloadScreen extends StatelessWidget {
  const HowToDownloadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How To Download"),
        centerTitle: true,
      ),
      body: stepsHolder(context),
    );
  }

  Widget stepsHolder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            "Steps",
            style: headingStyle(),
            textAlign: TextAlign.justify,
          ),
          Text(
            "1. Install any Torrent Client.",
            style: bodyStyle(),
            textAlign: TextAlign.justify,
          ),
          Text(
            "2. Press on desired quality button.",
            style: bodyStyle(),
            textAlign: TextAlign.justify,
          ),
          Text(
            "3. Add Torrent for Downloading.",
            style: bodyStyle(),
            textAlign: TextAlign.justify,
          ),
          Text(
            "4. You are Done. Now wait for Download to Complete.",
            style: bodyStyle(),
            textAlign: TextAlign.justify,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
          Text(
            "In-case of slow speed",
            style: headingStyle(),
            textAlign: TextAlign.justify,
          ),
          Text(
            "You can try adding Trackers from Trackers List. Well, by default, we have added recommended Trackers by yts.mx",
            style: bodyStyle(),
            textAlign: TextAlign.justify,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
          Text(
            "Suggested Torrent Clients",
            style: headingStyle(),
            textAlign: TextAlign.justify,
          ),
          InkWell(
            child: Container(
                margin: const EdgeInsets.only(top: 7.0),
                child: Text(
                  "1. qBittorrent",
                  style: linkStyle(),
                  textAlign: TextAlign.justify,
                )),
            onTap: () {
              Clipboard.setData(ClipboardData(text: "apt install qbittorrent"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copied to Clipboard"),
                    ));
            },
          ),
          InkWell(
            child: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "2. Deluge",
                  style: linkStyle(),
                  textAlign: TextAlign.justify,
                )),
            onTap: () {
              Clipboard.setData(ClipboardData(text: "apt install deluge"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copied to Clipboard"),
                    ));
            },
          ),
          InkWell(
            child: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "3. Transmission",
                  style: linkStyle(),
                  textAlign: TextAlign.justify,
                )),
            onTap: () {
              Clipboard.setData(ClipboardData(text: "apt install transmission"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copied to Clipboard"),
                    ));
            },
          ),
          InkWell(
            child: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "4. KTorrent",
                  style: linkStyle(),
                  textAlign: TextAlign.justify,
                )),
            onTap: () {
              Clipboard.setData(ClipboardData(text: "apt install ktorrent"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copied to Clipboard"),
                    ));
            },
          ),
          InkWell(
            child: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "5. Tixati",
                  style: linkStyle(),
                  textAlign: TextAlign.justify,
                )),
            onTap: () async {
              if (await canLaunch(
                  "https://www.tixati.com/download/linux.html")) {
                await launch(
                    "https://www.tixati.com/download/linux.html");
              } else {
                throw "Could not launch";
              }
            },
          ),
        ],
      ),
    );
  }

  TextStyle headingStyle() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
      letterSpacing: 1.5,
    );
  }

  TextStyle bodyStyle() {
    return const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
      letterSpacing: 1.0,
    );
  }

  TextStyle linkStyle() {
    return const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      color: Colors.deepPurpleAccent,
      letterSpacing: 1.0,
    );
  }
}
