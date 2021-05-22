import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/views/intro.dart';
import 'package:zumajobs/views/type.dart';

class Session extends StatefulWidget {
  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: 20),
        ProfileShimmer(
          hasBottomLines: true,
        ),
        SizedBox(height: 30),
        ProfileShimmer(
          hasBottomLines: true,
        ),
        SizedBox(height: 30),
        ProfileShimmer(
          hasBottomLines: true,
        ),
      ],
    ));
  }

  checkLogin() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    if (token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserType(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Intro(),
        ),
      );
    }
  }
}
