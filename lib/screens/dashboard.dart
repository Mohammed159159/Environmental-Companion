import 'package:bezier_chart/bezier_chart.dart';
import 'package:environmental_companion/module/tips.dart';
import 'package:environmental_companion/screens/homepage.dart';
import 'package:environmental_companion/widgets/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

bool buttonPressed = false;



class _DashBoardState extends State<DashBoard> {
  void refresh() {
    setState(() {
      buttonPressed = buttonPressed;
      fromDate = fromDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Colors.lightGreenAccent,
              Colors.greenAccent
            ])),
          ),
          Column(
            children: [
              Expanded(child: graph(context, refresh)),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      "How to increase your points!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 5,),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AnimationLimiter(
                          child: ListView.builder(
                            itemCount: tips.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: suggest(tips[index], 100, BoxFit.cover),
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
              )
            ],
          ),
        ],
      ),
    );
  }
}



var fromDate = DateTime.now().subtract(Duration(days: 7));
var toDate = DateTime.now();

Widget graph(BuildContext context, Function refresh) {
  final date1 = DateTime.now();
  final date2 = DateTime.now().subtract(Duration(days: 3));

  Widget timeButton(String txt, int subtract, Function refresh) {
    return InkResponse(
        onTap: () {
          fromDate = DateTime.now().subtract(Duration(days: subtract));
          refresh();
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            margin: EdgeInsets.only(left: 5, bottom: 10),
            width: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Colors.greenAccent,
                  Colors.lightGreenAccent
                ]),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)]),
            child: Text(
              txt,
              style: TextStyle(color: Colors.black54),
            )));
  }

  return Center(
    child: Stack(
      children: [
        BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Environs 🍀",
              onMissingValue: (dateTime) {
                if (dateTime.day == DateTime.now().day) {
                  return 0.0;
                }
                else if (dateTime.day.isEven) {
                  return 10.0;
                }
                else return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: environs.toDouble(), xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalLineFullHeight: true,
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundGradient: LinearGradient(
                colors: <Color>[Colors.lightGreenAccent, Colors.greenAccent]),
            footerHeight: 40.0,
          ),
        ),
        Positioned(
          top: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.date_range),
                color: Colors.white,
                onPressed: () {
                  buttonPressed = !buttonPressed;
                  refresh();
                },
              ),
              buttonPressed
                  ? Container(
                      child: Column(
                        children: [
                          timeButton("1 Year before", 365, refresh),
                          timeButton("1 Month before", 30, refresh),
                          timeButton("1 Week before", 7, refresh),
                        ],
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ],
    ),
  );
}
