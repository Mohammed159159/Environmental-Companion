import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:environmental_companion/screens/community.dart';
import 'package:environmental_companion/screens/dashboard.dart';
import 'package:environmental_companion/screens/homepage.dart';
import 'package:flutter/material.dart';

class Director extends StatefulWidget {
  @override
  _DirectorState createState() => _DirectorState();
}

int currentIndex = 1;

class _DirectorState extends State<Director> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.greenAccent,
        color: Colors.lightGreenAccent,
        items: <Widget>[
          Icon(Icons.dashboard),
          Icon(Icons.home),
          Icon(Icons.people_alt_rounded),
        ],
        index: 1,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        animationDuration: Duration(milliseconds: 400),
      ),
      body: currentIndex == 1 ? HomePage() : currentIndex == 0 ? DashBoard() : Community()
    );
  }
}
