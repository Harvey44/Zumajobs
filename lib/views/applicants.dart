import 'dart:async';
import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/applicant_resp.dart';
import 'package:zumajobs/models/model_resp.dart';
import 'package:zumajobs/views/emp/pay.dart';

class Applicants extends StatefulWidget {
  int id;
  Applicants({
    Key key,
    this.id,
  });
  @override
  _ApplicantsState createState() => _ApplicantsState();
}

class _ApplicantsState extends State<Applicants> {
  String key, type;
  bool premium = false;

  void initState() {
    // TODO: implement initState
    getKey();
    super.initState();
  }

  getKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      key = preferences.getString("token");
      type = preferences.getString("type");
      if (type == "employer") {
        premium = preferences.getBool("premium");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Page(context));
  }

  Page(context) {
    return SafeArea(
      child: Container(
        // margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Applicants",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
            Expanded(flex: 4, child: _buildApplicants(context)),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildApplicants(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    Map resp = {"key": key, "id": widget.id};
    var data = json.encode(resp);
    var h = MediaQuery.of(context).size.height / 3;
    return FutureBuilder<ApplicantResp>(
        future: Provider.of<ApiService>(context, listen: false).get_apps(data),
        builder: (BuildContext context, AsyncSnapshot<ApplicantResp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Something wrong"),
                ),
              );
            }
            ApplicantResp applicant = snapshot.data;
            return View(context, applicant);
          } else {
            return Column(
              children: [
                SizedBox(height: 20),
                ProfileShimmer(
                  hasBottomLines: true,
                ),
                SizedBox(height: 30),
                ProfileShimmer(
                  hasBottomLines: true,
                ),
              ],
            );
          }
        });
  }

  View(context, ApplicantResp applicant) {
    if (applicant.applicant.length == 0) {
      return Center(child: Text("No Applicant available in this job sector"));
    } else {
      return Container(
        color: const Color(0x0d3049ba),
        child: Applicants(context, applicant),
        // margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        // height: 200,..
      );
    }
  }

  ListView Applicants(context, ApplicantResp applicant) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: applicant.applicant.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        String last;
        if (type == "applicant") {
          last = '';
        } else if (type == "employer" && premium == false) {
          last = '';
        } else {
          last = StringUtils.capitalize(applicant.applicant[index].last_name);
        }
        return InkWell(
          onTap: () {
            postview(context, applicant.applicant[index].id);
            showCupertinoModalBottomSheet(
                context: context,
                duration: Duration(seconds: 2),
                builder: (context) =>
                    BottomSheetView(context, applicant, index));
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
              // mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 120,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 5, 10),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.grey[50],
                            backgroundImage: NetworkImage(
                              "https://zumajob.herokuapp.com${applicant.applicant[index].picture}",
                            ),
                          ),
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
                                        applicant.applicant[index].first_name) +
                                    " " +
                                    last,
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
                              applicant.applicant[index].skills,
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
                            child: Text(applicant.applicant[index].sector_name,
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
                            child: Text(applicant.applicant[index].country,
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

  BottomSheetView(context, ApplicantResp applicant, index) {
    String phone, last, email;
    print(type);
    if (type == "applicant") {
      phone = applicant.applicant[index].phone
          .replaceRange(4, applicant.applicant[index].phone.length, "******");
      last = applicant.applicant[index].last_name
          .replaceRange(2, applicant.applicant[index].last_name.length, "****");
      email = applicant.applicant[index].email
          .replaceRange(2, applicant.applicant[index].email.length, "****");
    } else if (type == "employer" && premium == false) {
      phone = applicant.applicant[index].phone
          .replaceRange(4, applicant.applicant[index].phone.length, "******");
      last = applicant.applicant[index].last_name
          .replaceRange(2, applicant.applicant[index].last_name.length, "****");
      email = applicant.applicant[index].email
          .replaceRange(2, applicant.applicant[index].email.length, "****");
    } else {
      phone = applicant.applicant[index].phone;
      last = StringUtils.capitalize(applicant.applicant[index].last_name);
      email = applicant.applicant[index].email;
    }

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
                    backgroundImage: NetworkImage(
                        "https://zumajob.herokuapp.com${applicant.applicant[index].picture}"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                        StringUtils.capitalize(
                                applicant.applicant[index].first_name) +
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
                    child: Text(applicant.applicant[index].skills,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Center(
                    child: Text(applicant.applicant[index].country,
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
                            child: Text(applicant.applicant[index].degree,
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
                                applicant.applicant[index].experience +
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
                                applicant.applicant[index].age + " Years Old",
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
                VideoView(context, applicant, index),
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
                    child: Text(applicant.applicant[index].about,
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
                InkWell(
                  onTap: () {
                    if (premium == true && type == 'employer') {
                      launch('mailto:$email');
                    }
                  },
                  child: Padding(
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
                InkWell(
                  onTap: () {
                    if (premium == true && type == 'employer') {
                      launch('tel:$phone');
                    }
                  },
                  child: Padding(
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
                            "https://zumajob.herokuapp.com${applicant.applicant[index].cv}";
                        getFile(context, applicant, index);
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
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  // Dio dio = Dio();
                  // var response = await dio.download(
                  //     "https://zumajob.herokuapp.com${applicant.applicant[index].cv}",
                  //     "/Downloads");
                  // // response.
                  if (premium == true && type == 'employer') {
                    _sendMail(applicant.applicant[index].email);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "You need to become a premium member to view email"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                        action: SnackBarAction(
                            label: 'Subscribe',
                            onPressed: () {
                              subscribe(context, applicant, index);
                            })));
                  }
                },
                label: Text(
                    "Contact ${StringUtils.capitalize(applicant.applicant[index].first_name)}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                backgroundColor: Colors.green),
          ),
        ));
  }

  subscribe(context, applicant, index) async {
    if (await canLaunch(applicant.link)) {
      await launch(applicant.link);
    } else {
      throw 'Could not launch ${applicant.link}';
    }
  }

  getFile(context, ApplicantResp applicant, index) async {
    if (type == "applicant") {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Only Employers can view applicant's CV"),
        backgroundColor: Colors.black,
        elevation: 30,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
      ));
    } else {
      if (premium == true) {
        if (await canLaunch(applicant.applicant[index].cv)) {
          await launch(applicant.applicant[index].cv);
        } else {
          throw 'Could not launch ${applicant.applicant[index].cv}';
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("You need to become a premium member to view CV"),
            backgroundColor: Colors.black,
            elevation: 30,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
            action: SnackBarAction(
                label: 'Subscribe',
                onPressed: () {
                  subscribe(context, applicant, index);
                })));
      }
    }
  }

  VideoView(context, applicant, index) {
    if (applicant.applicant[index].video == null) {
      return Container();
    } else {
      if (premium == true || type == 'applicant') {
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
            child: VideoWidget(applicant.applicant[index].video));
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
          height: 200,
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () => subscribe(context, applicant, index),
                  child: Icon(CupertinoIcons.lock_circle,
                      color: Colors.green, size: 25)),
              SizedBox(height: 10),
              InkWell(
                onTap: () => subscribe(context, applicant, index),
                child: Text(
                  "Become Premium member to unlock video",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
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

  _sendMail(email) async {
    var uri = 'mailto:$email?subject=From ZumaJobs&body=Hi  ...';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Failed';
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

    _controller = VideoPlayerController.network(
        'https://zumajob.herokuapp.com${widget.url}')
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
