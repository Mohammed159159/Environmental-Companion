import 'package:environmental_companion/module/cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

bool displayMenu = false;
int environs = 0;

class _HomePageState extends State<HomePage> {

  void refresh(CardData _cardData) {
    setState(() {
      _cardData.count = _cardData.count;
    });
  }

  void _refresh() {
    setState(() {
      displayMenu = displayMenu;
    });
  }

  void updateEnvirons(){
    setState(() {
      environs = environs;
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 1;
    return Scaffold(
      body: Stack(
        children: [
          background(),
          Column(
            children: [
              appBar(_refresh),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: cardData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                              child: _card(cardData[index], context, refresh, updateEnvirons)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          displayMenu ? Menu() : SizedBox.shrink(),
          Positioned(
            bottom: 10,
            right: 0,
            child: RaisedButton(
              color: Colors.greenAccent,
              shape: CircleBorder(),
              child: Icon(Icons.add),
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
  }
}

Widget background() {
  return Container(
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
  );
}

Widget appBar(Function refresh) {
  return Container(
    height: 120,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[Colors.lightGreenAccent, Colors.greenAccent]),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
        )),
    child: Row(
      children: [
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            displayMenu = !displayMenu;
            refresh();
          },
        ),
        Hero(tag: "logo", child: Image.asset("assets/logo.png")),
      ],
    ),
  );
}

Widget _card(CardData _cardData, context, Function refresh, Function updateEnvirons) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double cardHeight = height * 0.3;
  double cardWidth = width * 0.4;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: cardWidth,
            height: cardHeight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ]),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      _cardData.image,
                      fit: BoxFit.cover,
                      width: cardWidth,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _cardData.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      _cardData.count++;
                      refresh(_cardData);
                      environs++;
                      updateEnvirons();
                    },
                    color: Colors.white,
                    iconSize: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      _cardData.count--;
                      refresh(_cardData);
                      environs--;
                      updateEnvirons();
                    },
                    color: Colors.white,
                    iconSize: 50,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _cardData.count.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    ),
  );
}

// Menu

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

bool isMenuOpen = true;

class _MenuState extends State<Menu> {

  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  @override
  void initState() {
    limits = [0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double contLimit = position.dy + renderBox.size.height - 20;
    double step = (contLimit - start) / 3;
    limits = [];
    for (double x = start; x <= contLimit; x += step) {
      limits.add(x);
    }

    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    return _offset.dy > limits[x] && _offset.dy < limits[x + 1] ? 25 : 20;
  }

  @override
  Widget build(BuildContext context) {
    double heigthSize = MediaQuery.of(context).size.height;
    double widthSize = MediaQuery.of(context).size.width;
    double appbarWidth = widthSize * 0.75;
    double containerHeight = heigthSize / 2;

    Image image;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset = details.localPosition;
        });

        if (details.delta.dx <= appbarWidth &&
            details.delta.distanceSquared > 2)
          setState(() {
            isMenuOpen = true;
          });
      },
      onPanEnd: (details) {
        setState(() {
          _offset = Offset(0, 0);
        });
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            top: 0,
            left: isMenuOpen ? 0 : -appbarWidth + 20,
            curve: Curves.elasticOut,
            child: Container(
              color: Colors.white.withOpacity(0.0),
              width: isMenuOpen ? widthSize : appbarWidth,
              child: SizedBox(
                width: appbarWidth,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: DrawPainter(offset: _offset),
                      size: Size(appbarWidth, heigthSize),
                    ),
                    Container(
                      height: heigthSize * 0.85,
                      width: appbarWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: heigthSize * 0.25,
                            child: Center(
                              child: Column(
                                children: [
                                  image == null
                                      ? Icon(
                                          Icons.person,
                                          size: heigthSize * 3 / 18,
                                          color: Colors.black26,
                                        )
                                      : image,
                                  Text(
                                    "Username",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Environs: $environs",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      SizedBox(width: 5),
                                      Image.asset(
                                        "assets/leaf.png",
                                        height: 30,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          !isMenuOpen
                              ? SizedBox.shrink()
                              : Divider(
                                  thickness: 1,
                                ),
                          Container(
                            key: globalKey,
                            width: double.infinity,
                            height: containerHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyButton(
                                  text: "Comments",
                                  textSize: getSize(0),
                                  height: containerHeight / 3,
                                  width: appbarWidth,
                                  icon: Icons.comment,
                                ),
                                MyButton(
                                  text: "Settings",
                                  textSize: getSize(1),
                                  height: containerHeight / 3,
                                  width: appbarWidth - 50,
                                  icon: Icons.settings,
                                ),
                                MyButton(
                                  text: "Log Out",
                                  textSize: getSize(2),
                                  height: containerHeight / 3,
                                  width: appbarWidth - 70,
                                  icon: Icons.person_outline,
                                  implement: 2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 400),
                      right: isMenuOpen
                          ? widthSize - appbarWidth + 65
                          : appbarWidth,
                      bottom: 70,
                      child: IconButton(
                        icon: Icon(Icons.keyboard_backspace),
                        enableFeedback: true,
                        onPressed: () {
                          this.setState(() {
                            isMenuOpen = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final Offset offset;

  DrawPainter({this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightGreenAccent
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0.0);
    path.lineTo(size.width, 0.0);
    path.quadraticBezierTo(
        offset.dx <= size.width && offset.dy != 0
            ? size.width + 60
            : offset.dy == 0
                ? size.width + 60
                : offset.dx > size.width + 60 ? offset.dx : size.width + 60,
        offset.dy == 0 ? size.height * 0.5 : offset.dy,
        isMenuOpen ? size.width * 0.75 : size.width,
        size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  String text;
  IconData icon;
  double textSize;
  double height;
  double width;
  int implement;

  MyButton(
      {this.text,
      this.icon,
      this.textSize,
      this.height,
      this.width,
      this.implement});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Container(
        width: width,
        child: MaterialButton(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: textSize, color: Colors.black54),
                ),
              ],
            ),
            onPressed: () {
              if (implement == 2) {
                isMenuOpen = false;
              }
            }),
      ),
    );
  }
}
