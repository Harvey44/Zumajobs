import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/home_resp.dart';
import 'package:zumajobs/views/app/nav.dart';
import 'package:zumajobs/views/emp/nav.dart';

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  String key;
  HomeResp home;
  Future<HomeResp> future;

  void initState() {
    // TODO: implement initState
    getKey();
    super.initState();
  }

  getKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      key = preferences.getString("token");
    });
    getType();
    Map resp = {"key": key};
    var token = json.encode(resp);
    future = Provider.of<ApiService>(context, listen: false).get_home(token);
  }

  getType() async {
    Map data = {"key": key};
    var token = json.encode(data);

    try {
      final HomeResp response =
          await Provider.of<ApiService>(context, listen: false).get_home(token);
      if (response.status == true) {
        save(response);
        if (response.type == 'employer') {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => EmpNav()));
        } else if (response.type == 'applicant') {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => AppNav()));
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildHome(context));
  }

  FutureBuilder _buildHome(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    var h = MediaQuery.of(context).size.height / 3;
    return FutureBuilder<HomeResp>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<HomeResp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Something wrong"),
                ),
              );
            }
            home = snapshot.data;

            return Top(context, home);
          } else {
            return ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    ProfileShimmer(
                      hasBottomLines: true,
                    ),
                    SizedBox(height: 20),
                    ProfileShimmer(
                      hasBottomLines: true,
                    ),
                    SizedBox(height: 20),
                    ProfileShimmer(
                      hasBottomLines: true,
                    ),
                  ],
                ),
              ],
            );
          }
        });
  }

  Top(context, HomeResp home) {
    save(home);
    if (home.type == 'employer') {
      return EmpNav();
      // return WidgetsBinding.instance.addPostFrameCallback((_) {
      // return Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (_) => EmpNav()));
      // });
      // Future.microtask(() => Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (_) => EmpNav())));
    } else if (home.type == 'applicant') {
      return AppNav();
    }
  }

  save(HomeResp home) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("type", home.type);
    if (home.type == "applicant") {
      pref.setInt("views", home.applicant.views);
      pref.setInt("apply", home.applicant.applied);
    }
  }
}
