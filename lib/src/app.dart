import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yts_mx_desktop/screens/aboutUsScreen.dart';
import 'package:yts_mx_desktop/screens/announcementScreen.dart';
import 'package:yts_mx_desktop/screens/home.dart';
import 'package:yts_mx_desktop/screens/homeScreen.dart';
import 'package:yts_mx_desktop/screens/howToDownloadScreen.dart';
import 'package:yts_mx_desktop/screens/searchScreen.dart';
import 'package:yts_mx_desktop/screens/trackerListScreen.dart';
import 'package:yts_mx_desktop/screens/updateAppScreen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      title: "YTS.MX",
      home: const Home(),
      routes: {
        "/home": (_) => const Home(),
        "/homeScreen": (_) => const HomeScreen(),
        "/announcementScreen": (_) => const AnnouncementScreen(),
        "/howToDownloadScreen": (_) => const HowToDownloadScreen(),
        "/trackerListScreen": (_) => const TrackerListScreen(),
        "/updateAppScreen": (_) => const UpdateAppScreen(),
        "/aboutUsScreen": (_) => const AboutUsScreen(),
        "/searchScreen": (_) => const SearchScreen(),
      },
    );
  }

  ThemeData darkThemeData(BuildContext context) {
    return ThemeData(
      //0xFF6AC045
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      primaryColor: const Color(0xFF1D1D1D),
      backgroundColor: const Color(0xFF171717),
      indicatorColor: const Color(0xff0e1d36),
      hintColor: const Color(0xff280C0B),
      highlightColor: const Color(0xff372901),
      hoverColor: const Color(0xff3a3a3b),
      focusColor: const Color(0xff0b2512),
      disabledColor: Colors.grey,
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Colors.white,
      ),
      cardColor: const Color(0xFF151515),
      canvasColor: Colors.black,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: const ColorScheme.dark(),
          ),
    );
  }
}
