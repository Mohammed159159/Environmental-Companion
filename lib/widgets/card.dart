import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget suggest(dynamic tip, double height, BoxFit fit) {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  return InkWell(
      child: Container(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: Container(
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(tip.img), fit: fit)),
              child: tip.txt != null? Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                    tip.txt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ): SizedBox.shrink()
          )
      ),
      onTap: () => _launchURL(tip.link));
}