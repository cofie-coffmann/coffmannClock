import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, 
          DeviceOrientation.landscapeRight]);
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'clock',
      home: MyHomePage(title: 'Flutter clock Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Animation animation;
  Animation animation1;
  AnimationController animationController;
  bool _visible = true;
  bool wasCompleted = false;
    var form= NumberFormat('00', 'en_US');
  AnimationController animationController1;

  Animation<Offset> offset1;
  Animation<Offset> offset2;


_styleFont()    { 
  double height = MediaQuery.of(context).size.height;
  return TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[200],
                  fontSize: height * 0.14,
                  letterSpacing: 1.0,
                  shadows: <Shadow>[
                   _shadow() 
                  ]);}

_styleFontBig()    { 
  double height = MediaQuery.of(context).size.height;
  return TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[50],
                  fontSize: height * 0.42,
                  letterSpacing: 1.0,
                  shadows: <Shadow>[
                  _shadow() ]);}

 _shadow() {
   return Shadow(
                      offset: Offset(8, 8),
                      blurRadius: 3,
                      color: Color.fromARGB(35, 0, 0, 0),
                    );
 }

  _incrementCounter() {
    return "${form.format(DateTime.now().hour)} : ${form.format(DateTime.now().minute)}";
  }

  _incrementCounterPre() {
    if (DateTime.now().second > 59) {
      return SlideTransition(
          position: offset1,
          child: Container(
            child: Text("${form.format(DateTime.now().minute - 1)}",
                textAlign: TextAlign.end,
                style: _styleFont(),),
          ));
    } else if (DateTime.now().minute == 0) {
      double height = MediaQuery.of(context).size.height;
      return Transform(
          alignment: FractionalOffset(1, 0.5),
          transform:
              Matrix4.translationValues(0, animation.value * 0.15 * height, 0),
          child: Container(
            child: Text("O'clock",
                style: _styleFont(),),
          ));
    } else {
      if (DateTime.now().second == 59) {
        double height = MediaQuery.of(context).size.height;
        return Transform(
            alignment: FractionalOffset(1, 0.5),
            transform: Matrix4.translationValues(
                0, animation.value * 0.15 * height, 0),
            child: FadeTransition(
                opacity: Tween(
                  begin: 0.6,
                  end: 0.0,
                ).animate(CurvedAnimation(
                    parent: animationController1, curve: Curves.easeIn)),
                child: SlideTransition(
                    position: offset1,
                    child: Container(
                      child: Text("${form.format(DateTime.now().minute - 1)}",
                          style: _styleFont(),),
                    ))));
      } else {
        double height = MediaQuery.of(context).size.height;
        return Transform(
            alignment: FractionalOffset(1, 0.5),
            transform: Matrix4.translationValues(
                0, animation.value * 0.15 * height, 0),
            child: Container(
              child: Text("${form.format(DateTime.now().minute - 1)}",
               style: _styleFont(), )
                      ),
            );
      }
    }
  }

  _incrementCounterPost() {
    if (DateTime.now().second == 59) {
      double height = MediaQuery.of(context).size.height;
      return Transform(
          alignment: FractionalOffset(1, 0.5),
          transform:
              Matrix4.translationValues(0, animation.value * 0.15 * height, 0),
          child: FadeTransition(
              opacity: Tween(
                begin: 0.6,
                end: 0.0,
              ).animate(CurvedAnimation(
                  parent: animationController1, curve: Curves.easeIn)),
              child: SlideTransition(
                  position: offset1,
                  child: Container(
                    child: Text("${form.format(DateTime.now().minute + 1)}",
                    style: _styleFont(),),
                  ))));
    } else {
      double height = MediaQuery.of(context).size.height;
      return Transform(
          alignment: FractionalOffset(1, 0.5),
          transform:
              Matrix4.translationValues(0, animation.value * 0.15 * height, 0),
          child: Container(
            child: Text("${form.format(DateTime.now().minute + 1)}",
               style: _styleFont(),
           )),
          );
    }
  }

  _incrementCounterSec() {
    if (DateTime.now().second < 59) {
      return AnimatedOpacity(
          opacity: _visible ? 0.7 : 0.3,
          duration: Duration(seconds: 1),
          curve: Curves.easeInExpo,
          child: Text("${form.format(DateTime.now().second)}",
              style: _styleFont() ));
    }
  }

  _incrementaddSec() {
    double height = MediaQuery.of(context).size.height;
    if (DateTime.now().second > 59) {
      return SlideTransition(
          position: offset2,
          child: Icon(Icons.menu, size: height * 0.2, color: Colors.white));
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SlideTransition(
                  position: offset2,
                  child: Icon(Icons.menu, size: height * 0.2, color: Colors.white)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SlideTransition(
                  position: offset1, child: (_incrementCounterSec()))
            ]),
          ]);
    }
  }

  @override
  void initState() {
    super.initState();

    animationController1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController1.addListener(() {
      if (animationController1.isCompleted) {
        wasCompleted = true;
        animationController1.reverse();
      } 
      setState(() {
        _visible = !_visible;
      });
    });

    offset1 = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.0))
        .animate(animationController1);

    offset2 = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(-1.0, -1.0))
        .animate(animationController1);

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.reverse();
      } else if (animationController.isDismissed) {
        animationController.forward();
      }
      setState(() {
        _visible = !_visible;
      });
    });

    animationController.forward();
    animationController1.forward();
  }

  @override
  Widget build(BuildContext context) {
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation = Tween(begin: -0.5, end: 0.5).animate(animation);

    animation1 =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation1 = Tween(begin: -1, end: 0.5).animate(animation1);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AspectRatio(
        aspectRatio: 5 / 3,
        child: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                      Color(0xFFEF9A9A),
                      Color(0xFFFF5252),
                      Color(0xFFFF5252),
                      Color(0xFFD50000),
                      Color(0xFFD50000),
                    ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        tileMode: TileMode.clamp)),
                child: Stack(children: <Widget>[
                 Container(
                   alignment: Alignment( -0.2, 0.85),
                          height: height,
                          width: width,
                          padding: EdgeInsets.only(left: height * 0.084),
                          child: Row(
                       children: <Widget>[
                          SlideTransition(
                            position: offset2,
                            child: Icon(Icons.calendar_today,
                                size: height * 0.07, color: Colors.red[100])),
                                Text("${DateFormat.yMMMMEEEEd().format(DateTime.now())}",
                                
                                textAlign: TextAlign.end,
                                style: TextStyle(
                               fontWeight:
                                FontWeight.bold,
                                 color: Colors.red[100],
                                 fontSize: height * 0.056,
                                 letterSpacing: 1.0,
                                 shadows: <Shadow>[
                                   _shadow() 
                                 ]
                                ))])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: height * 0.056,
                        ),
                          width: width * 0.735,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left:  width * 0.725 * 0.61,
                                        ),
                                      ),
                                      (_incrementCounterPost())
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FadeTransition(
                                          opacity: Tween(
                                            begin: 1.0,
                                            end: 0.0,
                                          ).animate(CurvedAnimation(
                                              parent: animationController1,
                                              curve: Curves.easeIn)),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(_incrementCounter(),
                                                    style: _styleFontBig(),
                                                    )]),
                                )]),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width * 0.725 * 0.61,
                                        ),
                                      ),
                                      (_incrementCounterPre())
                                    ]),
                              ])),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.225,
                        child: _incrementaddSec(),
                      ),
                    ],
                  ),
                ]))));
  }
}