import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget headerTabs(BuildContext context) {
  return FittedBox(
    fit: BoxFit.contain,
    child: Row(
      children: [
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          },
          icon: const Icon(
            Icons.home_outlined,
            size: 26.0,
          ),
          label: const Text(
            "Home",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/announcementScreen");
          },
          icon: const Icon(
            Icons.notifications_active_outlined,
            size: 23.0,
          ),
          label: const Text(
            "Announcements",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/howToDownloadScreen");
          },
          icon: const Icon(
            Icons.workspaces_outline,
            size: 23.0,
          ),
          label: const Text(
            "How to Download",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/trackerListScreen");
          },
          icon: const Icon(
            Icons.link,
            size: 23.0,
          ),
          label: const Text(
            "Tracker List",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton.icon(
          onPressed: () async {
            const String _formUrl =
                "https://docs.google.com/forms/d/e/1FAIpQLSdFwATdFCd2N-4hO_omPInGzxCWh13m8Px8o01xF4Q3TreaqA/viewform?usp=sf_link";
            if (await canLaunch(_formUrl)) {
              await launch(_formUrl);
            }
          },
          icon: const Icon(
            Icons.bug_report_outlined,
            size: 23.0,
          ),
          label: const Text(
            "Report a Problem",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/updateAppScreen");
          },
          icon: const Icon(
            Icons.system_update,
            size: 23.0,
          ),
          label: const Text(
            "Updates",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/aboutUsScreen");
          },
          icon: const Icon(
            Icons.info_outline,
            size: 23.0,
          ),
          label: const Text(
            "About Us",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
