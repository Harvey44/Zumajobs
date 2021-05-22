import 'dart:async';
import 'dart:convert';

import 'package:adobe_xd/pinned.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/home_resp.dart';
import 'package:zumajobs/models/model_resp.dart';
import 'package:zumajobs/models/vacancy_resp.dart';
import 'package:zumajobs/views/app/aProfile.dart';
import 'package:zumajobs/views/app/search.dart';
import 'package:zumajobs/views/app/vacancy.dart';
import 'package:zumajobs/views/intro.dart';
import 'package:zumajobs/views/privacy.dart';

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  String key;
  Future<HomeResp> future;
  TextEditingController scontroller = TextEditingController();
  GlobalKey btnKey = GlobalKey();
  var scaffoldkey = GlobalKey<ScaffoldState>();
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
    Map resp = {"key": key};
    var token = json.encode(resp);
    future = Provider.of<ApiService>(context, listen: false).get_home(token);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
            key: scaffoldkey,
            backgroundColor: Colors.white,
            drawer: Drawer(
                child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                      child: Text("ZumaJobs",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22))),
                  decoration: BoxDecoration(color: Colors.white),
                ),
                ListTile(
                    title: Text("Privacy Policy"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Privacy(),
                        ),
                      );
                    }),
                ListTile(
                    title: Text("Share the app"),
                    onTap: () {
                      Share.share(
                          "Check out this cool job search app : Zuma Jobs");
                    }),
                ListTile(
                    title: Text("Logout"),
                    onTap: () {
                      logout(context);
                    }),
              ],
            )),
            body: _buildHome(context)));
  }

  FutureBuilder _buildHome(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    Map resp = {"key": key};
    var token = json.encode(resp);
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
            HomeResp home = snapshot.data;
            return Top(context, home);
          } else {
            return Column(
              children: [
                ProfileShimmer(
                  hasBottomLines: true,
                ),
                SizedBox(height: 10),
                ProfileShimmer(
                  hasBottomLines: true,
                ),
                SizedBox(height: 10),
                ProfileShimmer(
                  hasBottomLines: true,
                ),
              ],
            );
          }
        });
  }

  Top(context, HomeResp home) {
    if (home.applicant.picture == null) {
      return AProfile();
    } else {
      return Page(context, home);
    }
  }

  Page(context, HomeResp home) {
    return SafeArea(
      child: Container(
        // margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: InkWell(
                    onTap: () {
                      // menu.show(widgetKey: btnKey);
                      scaffoldkey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 20,
                      key: btnKey,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Applicants",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                height: 40,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1a7364f8),
                      offset: Offset(-2.723942995071411, 5.346039295196533),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: scontroller,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Search(query: value)));
                  },
                  style:
                      TextStyle(fontSize: 14, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    focusColor: Colors.black,
                    hoverColor: Colors.black,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    hintText: "Search for vacancy",
                    suffixIcon: InkWell(
                      child: Icon(CupertinoIcons.search, color: Colors.green),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => Search(query: scontroller.text)));
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(flex: 4, child: View(context, home)),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  View(context, HomeResp home) {
    if (home.applicants.length == 0) {
      return Center(child: Text("No Applicant available in this job sector"));
    } else {
      return Container(
        color: const Color(0x0d3049ba),
        child: Applicants(context, home),
        // margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        // height: 200,..
      );
    }
  }

  ListView Applicants(context, HomeResp home) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: home.applicants.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            postview(context, home.applicants[index].id);
            showCupertinoModalBottomSheet(
                context: context,
                duration: Duration(seconds: 2),
                builder: (context) => BottomSheetView(context, home, index));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(4, 4, 4, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1a7364f8),
                  offset: Offset(-2.723942995071411, 5.346039295196533),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[50],
                          backgroundImage:
                              NetworkImage(home.applicants[index].picture),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Text(
                                StringUtils.capitalize(
                                    home.applicants[index].first_name),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(
                              home.applicants[index].skills,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0x0d3049ba),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(CupertinoIcons.waveform,
                                color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(home.applicants[index].sector_name,
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(CupertinoIcons.location,
                                color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(home.applicants[index].country,
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  logout(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Intro()),
        (Route<dynamic> route) => false);
  }

  BottomSheetView(context, HomeResp home, index) {
    String phone, last, email;

    phone = home.applicants[index].phone
        .replaceRange(4, home.applicants[index].phone.length, "******");
    last = home.applicants[index].last_name
        .replaceRange(2, home.applicants[index].last_name.length, "****");
    email = home.applicants[index].email
        .replaceRange(2, home.applicants[index].email.length, "****");

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(MaterialIcons.keyboard_backspace)),
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[50],
                    backgroundImage:
                        NetworkImage(home.applicants[index].picture),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                        StringUtils.capitalize(
                                home.applicants[index].first_name) +
                            " " +
                            last,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Center(
                    child: Text(home.applicants[index].skills,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Center(
                    child: Text(home.applicants[index].country,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            fontSize: 12)),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0x1aff8d8d),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1a7364f8),
                            offset:
                                Offset(-2.723942995071411, 5.346039295196533),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Image(
                                image:
                                    AssetImage("assets/images/exp_icon.png")),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(home.applicants[index].degree,
                                textAlign: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0x1ad5be5d),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1a7364f8),
                            offset:
                                Offset(-2.723942995071411, 5.346039295196533),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Image(
                                image:
                                    AssetImage("assets/images/work_icon.png")),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(
                                home.applicants[index].experience +
                                    " Experience",
                                textAlign: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0x1a5dd583),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1a5dd583),
                            offset:
                                Offset(-2.723942995071411, 5.346039295196533),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Icon(CupertinoIcons.person_fill,
                                color: Colors.greenAccent),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 7, 5, 24),
                            child: Text(
                                home.applicants[index].age + " Years Old",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                VideoView(context, home.applicants[index].video),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("About",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(home.applicants[index].about,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1.2)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Email Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(email,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1.2)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Phone Number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(phone,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1.2)),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    // width: 100,
                    height: 36,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: RaisedButton(
                      child: Text(
                        "Download CV",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        String url =
                            "https://zumajob.herokuapp.com${home.applicants[index].cv}";
                        getFile(context, url);
                      },
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.green,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ));
  }

  getFile(context, url) async {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Only Employers can view applicant's cv"),
      backgroundColor: Colors.black,
      elevation: 30,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
    ));
  }

  VideoView(context, url) {
    if (url == "" || url == null) {
      return Container();
    } else {
      return Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x1a7364f8),
                offset: Offset(-2.723942995071411, 5.346039295196533),
                blurRadius: 18,
              ),
            ],
          ),
          // height: 200,
          width: MediaQuery.of(context).size.width - 20,
          child: VideoWidget(url));
    }
  }

  postview(context, id) async {
    Map resp = {"id": id, "key": key};
    var data = json.encode(resp);

    try {
      final ModelResp response =
          await Provider.of<ApiService>(context, listen: false).post_view(data);
      if (response.message == "Success") {
      } else {}
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        print(e.message);
      }
    }
  }
}

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget(this.url);

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  Widget videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = Container();

    _controller = VideoPlayerController.network(widget.url)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        Timer(Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1 / 1,
        child: _controller.value.initialized ? videoPlayer() : Container(),
      );

  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Center(child: videoStatusAnimation),
        ],
      );

  Widget video() => GestureDetector(
        child: VideoPlayer(_controller),
        onTap: () {
          if (!_controller.value.initialized) {
            return;
          }
          if (_controller.value.isPlaying) {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            _controller.pause();
          } else {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
            _controller.play();
          }
        },
      );
}

class FadeAnimation extends StatefulWidget {
  const FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 1000)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController.isAnimating
      ? Opacity(
          opacity: 1.0 - animationController.value,
          child: widget.child,
        )
      : Container();
}
