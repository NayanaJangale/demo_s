import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/app_data.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/login_page.dart';
import 'package:student/pages/select_ward_page.dart';

class WelcomePage extends StatelessWidget {
  final SharedPreferences preferences;

  const WelcomePage({this.preferences});

  @override
  Widget build(BuildContext context) {
    AppData.current.preferences = this.preferences;
    Duration threeSeconds = Duration(seconds: 3);
    Future.delayed(threeSeconds, () {
      checkCurrentLogin(context);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset(
                'assets/images/soft_campus_logo.png',
                width: MediaQuery.of(context).size.width / 2.2,
              ),
              WavyHeader(),
            ],

          ),
          Padding(
            padding: const EdgeInsets.only(right: 100,top: 0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Text("Student App",style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ),),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              WavyFooter(),
              CirclePink(),
              CircleYellow(),
            ],
          )
        ],
      )
    );
  }
  Future<void> checkCurrentLogin(BuildContext context) async {
    try {
      User user = await DBHandler().getLoggedInUser();

      if (user != null && user.remember_me == 1) {
        AppData.current.user = user;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SelectWardPage(),
            // builder: (_) => SubjectsPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(),
            // builder: (_) => SubjectsPage(),
          ),
        );
      }
    } catch (e) {}
  }
}

List<Color> orangeGradients(BuildContext context) {
  return [
    Theme.of(context).accentColor,
    Theme.of(context).primaryColor,
    Theme.of(context).primaryColorDark,
  ];
}

List<Color> aquaGradients(BuildContext context) {
  return [
    Theme.of(context).primaryColorLight,
    Theme.of(context).primaryColor,
  ];
}

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: orangeGradients(context),
              begin: Alignment.topLeft,
              end: Alignment.center),
        ),
        height: MediaQuery.of(context).size.height / 2.5,
      ),
    );
  }
}

class WavyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: aquaGradients(context),
              begin: Alignment.center,
              end: Alignment.bottomRight),
        ),
        height: MediaQuery.of(context).size.height / 3,
      ),
    );
  }
}

class CirclePink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-70.0, 90.0),
      child: Material(
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(padding: EdgeInsets.all(120)),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
      ),
    );
  }
}

class CircleYellow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, 210.0),
      child: Material(
        color: Theme.of(context).primaryColorLight,
        child: Padding(padding: EdgeInsets.all(140)),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
    Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class YellowCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
