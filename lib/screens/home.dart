import 'package:flutter/material.dart';
import 'package:yts_mx_desktop/screens/appDrawer.dart';
import 'package:yts_mx_desktop/screens/filterScreen.dart';
import 'package:yts_mx_desktop/screens/homeScreen.dart';

class Home extends StatefulWidget {
  final String? quality;
  final int? minimumRating;
  final String? genre;
  final String? sortBy;
  final String? orderBy;

  const Home(
      {Key? key,
      this.quality,
      this.minimumRating,
      this.genre,
      this.sortBy,
      this.orderBy})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _activated = false;

  String? quality;
  int? minimumRating;
  String? genre;
  String? sortBy;
  String? orderBy;

  @override
  Widget build(BuildContext context) {
    quality = widget.quality ?? "All";
    minimumRating = widget.minimumRating ?? 0;
    genre = widget.genre ?? "All";
    sortBy = widget.sortBy ?? "year";
    orderBy = widget.orderBy ?? "desc";

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/logo-YTS.png",
        ),
        actions: [
          searchButton(context),
          filterButton(context),
        ],
      ),
      body: _activated
          ? FilterScreen(
              quality: quality,
              minimumRating: minimumRating,
              genre: genre,
              sortBy: sortBy,
              orderBy: orderBy,
            )
          : HomeScreen(
              quality: widget.quality,
              minimumRating: widget.minimumRating,
              genre: widget.genre,
              sortBy: widget.sortBy ?? "year",
              orderBy: widget.orderBy),
      drawer: appDrawer(context),
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

  TextButton filterButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (_activated) {
          _activated = false;
        } else {
          _activated = true;
        }
        setState(() {});
      },
      icon: Icon(
        _activated ? Icons.clear : Icons.filter_alt,
        size: 30.0,
      ),
      label: _activated
          ? Text(
              "Close",
              style: labelStyle(),
            )
          : Text(
              "Filter",
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
