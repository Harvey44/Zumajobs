import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/sector.dart';
import 'package:zumajobs/models/sector_resp.dart';
import 'package:zumajobs/models/user_resp.dart';
import 'package:zumajobs/views/app/home.dart';

class AProfile extends StatefulWidget {
  @override
  _AProfileState createState() => _AProfileState();
}

class _AProfileState extends State<AProfile> {
  String key;
  Future<UserResp> future;
  File _image, _video, _cv;
  final picker = ImagePicker();
  TextEditingController pcontroller = TextEditingController();
  TextEditingController fcontroller = TextEditingController();
  TextEditingController lcontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController scontroller = TextEditingController();
  TextEditingController acontroller = TextEditingController();
  TextEditingController econtroller = TextEditingController();
  String level, picture, cv;
  String dob;
  String upload_status = "Upload Profile Video";
  List<String> sectorlist = [];
  String sector;
  String exp = "e.g 4 years";
  List<String> degree = [
    'Bachelor\'s Degree',
    'Diploma',
    'High School',
    'Master\'s Degree',
    'Bachelor of Medicine',
    'Bachelor of Surgery (MBBS)',
    'Professional Degree (MBA)',
    'Doctorate Degree (Ph.D)'
  ];

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
    future = Provider.of<ApiService>(context, listen: false).get_user(token);
    getSector();
    getUser();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future pickCameraMedia(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pop();
    final getMedia = ImagePicker().getVideo;
    setState(() {
      upload_status = "Uploading ...";
      _video = null;
    });
    final media = await getMedia(
        source: ImageSource.camera, maxDuration: Duration(seconds: 60));
    // final file = File(media.path);
    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      media.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: true,
      includeAudio: true,
    );

    setState(() {
      if (info.path != null) {
        final file = File(info.path);
        _video = file;
        upload_status = "Upload Profile Video";
      }
    });
  }

  Future getFile() async {
    File file = await FilePicker.getFile();

    setState(() {
      _cv = file;
    });
  }

  getSector() async {
    Map data = {"key": key};
    var token = json.encode(data);

    try {
      final SectorResp response =
          await Provider.of<ApiService>(context, listen: false)
              .get_sector(token);
      if (response.status == true) {
        setState(() {
          for (int i = 0; i < response.sector.length; i++) {
            sectorlist.add(response.sector[i].name);
          }
        });
      }
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        print(e.message);
      }
    }
  }

  getUser() async {
    Map data = {"key": key};
    var token = json.encode(data);

    try {
      final UserResp response =
          await Provider.of<ApiService>(context, listen: false).get_user(token);
      if (response.status == true) {
        setState(() {
          pcontroller.text = response.applicant.phone;
          fcontroller.text = response.applicant.first_name;
          dobcontroller.text = response.applicant.age;
          lcontroller.text = response.applicant.last_name;
          scontroller.text = response.applicant.sector_name;
          acontroller.text = response.applicant.about;
          econtroller.text = response.applicant.experience;
          picture = response.applicant.picture;
          cv = response.applicant.cv;
        });
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
    return Scaffold(backgroundColor: Colors.white, body: Page(context));
  }

  Page(context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AppHome(),
                        ),
                      );
                    },
                    child: Icon(
                      MaterialIcons.keyboard_backspace,
                      color: Colors.black,
                      size: 20,
                    )),
                InkWell(
                  onTap: () {
                    if (pcontroller.text == null || pcontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Input Phone Number"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (fcontroller.text == null ||
                        fcontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Enter First Name"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (lcontroller.text == null ||
                        fcontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Enter Last Name"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (dobcontroller.text == null ||
                        dobcontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Enter Your Age"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (econtroller.text == null ||
                        econtroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Enter Work Experience"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (acontroller.text == null ||
                        acontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Please Input A Short Profile About Yourself"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (level == null || level == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select Highest Degree"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (sector == null || sector == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select Job Sector"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (_image == null && picture == null) {
                      // post_user(context, _image);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please Upload Profile Picture"),
                          backgroundColor: Colors.black,
                          elevation: 30,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 70)));
                    } else if (upload_status == "Uploading ...") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Video Upload in Progress"),
                          backgroundColor: Colors.black,
                          elevation: 30,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 70)));
                    } else if (_cv == null && cv == null) {
                      // post_user(context, _image);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please Upload CV"),
                          backgroundColor: Colors.black,
                          elevation: 30,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 70)));
                    } else {
                      post_user(context, _image, _video, _cv);
                    }
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text("Save",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Edit Portfolio",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
            Expanded(flex: 4, child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildBody(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    Map resp = {"key": key};
    var token = json.encode(resp);
    var h = MediaQuery.of(context).size.height / 3;
    return FutureBuilder<UserResp>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<UserResp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Something wrong"),
                ),
              );
            }
            UserResp user = snapshot.data;
            // pcontroller.text = user.applicant.phone;
            // fcontroller.text = user.username;
            // dobcontroller.text = user.applicant.age;

            if (user.applicant.experience != "") {
              exp = user.applicant.experience;
              level = user.applicant.degree;
              sector = user.applicant.sector_name;
            }
            // namecontroller.text = user.employer.company_name;
            // regcontroller.text = user.employer.phone;
            return View(context, user);
          } else {
            return Column(
              children: [
                SizedBox(height: 10),
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

  View(context, UserResp user) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[50],
                    backgroundImage: NetworkImage(
                        "https://zumajob.herokuapp.com${user.applicant.picture}"),
                  ),
                ),
              ),
              InkWell(
                onTap: getImage,
                child: Container(
                  width: 100,
                  height: 70,
                  child: Center(
                    child: _image == null
                        ? Text('Upload Profile Picture',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold))
                        : Image.file(_image),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Email Address",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text(user.applicant.email,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("First Name",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 40,
              // // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: fcontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    focusColor: Colors.black,
                    hoverColor: Colors.black,
                    hintText: user.applicant.first_name),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Last Name",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 40,
              // // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: lcontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    focusColor: Colors.black,
                    hoverColor: Colors.black,
                    hintText: user.applicant.last_name),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Age",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 40,
              // // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                controller: dobcontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0.0),
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                  hintText: user.applicant.age,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Phone Number",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              height: 40,
              // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))
                ],
                controller: pcontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: user.applicant.phone),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text("Skill",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              height: 40,
              // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: scontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    hintStyle: TextStyle(fontSize: 12),
                    hintText: "e.g Oil Broker"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text("Work Experience",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              height: 40,
              // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))
                ],
                controller: econtroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    hintStyle: TextStyle(fontSize: 12),
                    hintText: 'How many years experience'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text("About me",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          IntrinsicHeight(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                // height: 50,
                // width: 120,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  expands: true,
                  maxLines: null,
                  controller: acontroller,
                  // maxLines: 2,
                  maxLengthEnforced: true,
                  maxLength: 150,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintStyle: TextStyle(fontSize: 12),
                    hintText: user.applicant.about,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              showSelectedItem: true,
              enabled: true,
              items: degree,
              selectedItem: level,
              label: "Select Qualification Level",
              onChanged: (String item) {
                setState(() {
                  level = item;
                  print(level);
                });
              },
              // maxHeight: 45,
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              showSelectedItem: true,
              enabled: true,
              items: sectorlist,
              selectedItem: sector,
              label: "Select Area Of Experience",
              onChanged: (String item) {
                setState(() {
                  sector = item;
                  // print(level);
                });
              },
              // maxHeight: 45,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      child: _video == null
                          ? VideoView(context, user)
                          : VideoWidget(_video)),
                  Container(
                    // width: 100,
                    height: 36,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: RaisedButton(
                      child: Text(
                        upload_status,
                        style: TextStyle(color: Colors.green, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        videotip(context);
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
              Column(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      child: _cv == null
                          ? Icon(CupertinoIcons.book, size: 20)
                          : Text(path.basename(_cv.path))),
                  Container(
                    // width: 100,
                    height: 36,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: RaisedButton(
                      child: Text(
                        "Upload CV",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        getFile();
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
            ],
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }

  VideoView(context, UserResp user) {
    if (user.applicant.video == "") {
      return Icon(CupertinoIcons.video_camera, size: 20);
    } else {
      return VideoWidgets(user.applicant.video);
    }
  }

  videotip(context) {
    var alertDialog = AlertDialog(
      title: Text("Upload Profile Video (Optional)",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16.0)),
      content: Text(
          "Upload video telling the recruiter why you are qualified for the job, not more than 1 minute."),
      actions: <Widget>[
        FlatButton(
          child: Text("Upload",
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0)),
          onPressed: () => pickCameraMedia(context),
        ),
        // SizedBox(height: 10),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  post_user(context, File imageFile, File video, File cv) async {
    // open a bytestream

    var uri = Uri.parse("https://zumajob.herokuapp.com/api/postprofile");
    var request = new http.MultipartRequest("POST", uri);
    var streams, lengths, stream, length, cvstream, cvlength;
    var multipartFiles;
    var multipartFile;
    var cvmultipartFile;

    // get file length

    if (video != null) {
      streams = new http.ByteStream(DelegatingStream.typed(video.openRead()));
      // get file length
      lengths = await video.length();

      multipartFiles = new http.MultipartFile('video', streams, lengths,
          filename: path.basename(video.path));

      request.files.add(multipartFiles);
    } else {
      request.fields['video'] = "";
    }

    //
    if (imageFile != null) {
      stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      length = await imageFile.length();

      multipartFile = new http.MultipartFile('picture', stream, length,
          filename: path.basename(imageFile.path));

      request.files.add(multipartFile);
    } else {
      request.fields['picture'] = "";
    }
    //
    //
    if (cv != null) {
      cvstream = new http.ByteStream(DelegatingStream.typed(cv.openRead()));
      // get file length
      cvlength = await cv.length();
      cvmultipartFile = new http.MultipartFile('cv', cvstream, cvlength,
          filename: path.basename(cv.path));

      request.files.add(cvmultipartFile);
    } else {
      request.fields['cv'] = "";
    }
    //

    // string to uri

    // create multipart request

    request.fields['key'] = key;
    request.fields['phone'] = pcontroller.text;
    request.fields['degree'] = level;
    request.fields['age'] = dobcontroller.text;
    request.fields['first_name'] = fcontroller.text;
    request.fields['last_name'] = lcontroller.text;
    request.fields['sector'] = sector;
    request.fields['skills'] = scontroller.text;
    request.fields['exp'] = econtroller.text + " Years";
    request.fields['about'] = acontroller.text;

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, textDirection: TextDirection.ltr);
    pr.style(message: "Saving Profile ...");
    pr.show();
    // send
    try {
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        pr.hide();
        CoolAlert.show(
            confirmBtnText: "Done",
            onConfirmBtnTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AppHome()));
            },
            context: context,
            type: CoolAlertType.success,
            text: "Changes Saved");
      } else {
        pr.hide();
        CoolAlert.show(
            showCancelBtn: true,
            context: context,
            type: CoolAlertType.error,
            text: "Request Failed");
      }

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } on DioError catch (e) {
      if (e.response = null) {
        pr.hide();
        CoolAlert.show(
            showCancelBtn: true,
            context: context,
            type: CoolAlertType.error,
            text: "Request Failed");
      } else {
        print(e.message);
        pr.hide();
        CoolAlert.show(
            showCancelBtn: true,
            context: context,
            type: CoolAlertType.error,
            text: "Request Failed");
      }
    }
  }
}

class VideoWidget extends StatefulWidget {
  final File file;

  const VideoWidget(this.file);

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

    _controller = VideoPlayerController.file(widget.file)
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
        aspectRatio: 16 / 9,
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

class VideoWidgets extends StatefulWidget {
  final String url;

  const VideoWidgets(this.url);

  @override
  VideoWidgetsState createState() => VideoWidgetsState();
}

class VideoWidgetsState extends State<VideoWidgets> {
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
