import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/views/app/slide.dart';
import 'package:zumajobs/views/emp/slide.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(MaterialIcons.keyboard_backspace),
              ),
            ),
            SizedBox(height: 100),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text('Select account type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                Container(
                  width: 280,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: RaisedButton(
                    child: Text(
                      "Proceed As An Applicant",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => AppSlide()));
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),

                      // side: BorderSide(color: Colors.)
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  width: 280,
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      "Proceed As An Employer",
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => EmpSlide()));
                    },
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(
                          color: Colors.green,
                        )),
                  ),
                ),
              ],
            )),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(

                    //     MaterialPageRoute(

                    //         builder: (_) => Terms()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                          text: "Product of ",
                          style: TextStyle(fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'WorkPride Limited Liability Company.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    decoration: TextDecoration.underline))
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Top() {
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(MaterialIcons.keyboard_backspace),
            ),
          ),
        ),
        SizedBox(height: 40),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Select account type',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 180,
                height: 36,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: RaisedButton(
                  child: Text(
                    "HIRE A CHEF",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onPressed: () {},
                  color: const Color(0xffc50fb3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                    // side: BorderSide(color: Colors.)
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15.0),

                width: 250,

                // height: 40,

                child: RaisedButton(
                  child: Text(
                    "WORK AS A CHEF",
                    style:
                        TextStyle(color: const Color(0xffc50fb3), fontSize: 14),
                  ),
                  onPressed: () {},
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.green,
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.of(context).push(

                  //     MaterialPageRoute(

                  //         builder: (_) => Terms()));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                        text: "By joining, you agree to Yardcook's ",
                        style: TextStyle(fontSize: 12.0),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Terms and Conditions and Privacy Policy.',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  decoration: TextDecoration.underline))
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
