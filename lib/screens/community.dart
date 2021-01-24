import 'package:environmental_companion/module/tips.dart';
import 'package:environmental_companion/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
                "Check out those communities!",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          SizedBox(height: 10,),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: communities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: suggest(communities[index], 200, BoxFit.fill),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
