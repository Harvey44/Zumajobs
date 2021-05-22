import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:zumajobs/views/login.dart';
import 'package:zumajobs/views/register.dart';

class EmpSlide extends StatefulWidget {
  @override
  _EmpSlideState createState() => _EmpSlideState();
}

class _EmpSlideState extends State<EmpSlide> {
  List<Slide> slides = new List();
  @override
  void initState() {
    // TODO: implement initState
    slides.add(
      new Slide(
        title: "Add your company profile",
        description:
            "Tell us about your company by submitting relevant informations and uploading requested document.",
        pathImage: "assets/images/profile.jpg",
        backgroundColor: Colors.white,
        maxLineTitle: 2,
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    );
    slides.add(
      new Slide(
        title: "View qualified applicants in our directory",
        description:
            "View resume of job applicants from different job categories",
        pathImage: "assets/images/select.jpg",
        backgroundColor: Colors.white,
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    );
    slides.add(
      new Slide(
        title: "Contact and hire",
        maxLineTitle: 1,
        description:
            "Contact desired applicants and work out employment details",
        pathImage: "assets/images/hiring.jpg",
        backgroundColor: Colors.white,
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    );
    super.initState();
  }

  void onDonePress() {
// Do what you want
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.green,
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.green,
      size: 25.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: IntroSlider(
                  shouldHideStatusBar: false,
                  slides: this.slides,
                  onDonePress: this.onDonePress,
                  renderSkipBtn: this.renderSkipBtn(),
                  renderNextBtn: this.renderNextBtn(),

                  // Done button
                  renderDoneBtn: this.renderDoneBtn(),
                ),
              ),
              Expanded(flex: 1, child: SigninButton(context))
            ],
          )),
    );
  }

  Widget SigninButton(context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 150,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: RaisedButton(
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Register(type: 'employer'),
                    ),
                  );
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),

                  // side: BorderSide(color: Colors.)
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: 150,
              height: 40,
              child: RaisedButton(
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.green,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
