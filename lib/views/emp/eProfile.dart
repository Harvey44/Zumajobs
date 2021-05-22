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
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/sector_resp.dart';
import 'package:zumajobs/models/user_resp.dart';
import 'package:zumajobs/views/emp/home.dart';

class EProfile extends StatefulWidget {
  @override
  _EProfileState createState() => _EProfileState();
}

class _EProfileState extends State<EProfile> {
  String key;
  Future<UserResp> future;
  File _image;
  final picker = ImagePicker();
  TextEditingController pcontroller = TextEditingController();
  TextEditingController fcontroller = TextEditingController();
  TextEditingController lcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController regcontroller = TextEditingController();
  List<String> sectorlist = [];
  String sector;
  String logo, cert_url;
  File cert;

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

  Future getFile() async {
    File file = await FilePicker.getFile();

    setState(() {
      cert = file;
    });
  }

  getUser() async {
    Map data = {"key": key};
    var token = json.encode(data);

    try {
      final UserResp response =
          await Provider.of<ApiService>(context, listen: false).get_user(token);
      if (response.status == true) {
        setState(() {
          pcontroller.text = response.employer.phone;

          addresscontroller.text = response.employer.company_address;

          regcontroller.text = response.employer.reg_number;

          namecontroller.text = response.employer.company_name;

          sector = response.employer.sector_name;

          logo = response.employer.logo;
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
                          builder: (context) => EmpHome(),
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
                    } else if (namecontroller.text == null ||
                        namecontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Enter Company Name"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (addresscontroller.text == null ||
                        addresscontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please Enter Company Address"),
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
                    } else if (regcontroller.text == null ||
                        regcontroller.text == "") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Please Enter Company Registration Number"),
                        backgroundColor: Colors.black,
                        elevation: 30,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 70),
                      ));
                    } else if (_image == null && logo == null) {
                      // post_user(context, _image);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please Upload Company Logo"),
                          backgroundColor: Colors.black,
                          elevation: 30,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 70)));
                    } else if (cert == null && logo == null) {
                      // post_user(context, _image);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please Upload Company's Certificate"),
                          backgroundColor: Colors.black,
                          elevation: 30,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 70)));
                    } else {
                      post_user(context, _image, cert);
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
                child: Text("Edit Company Profile",
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
            // pcontroller.text = user.employer.phone;
            // fcontroller.text = user.employer.first_name;
            // lcontroller.text = user.employer.last_name;
            // namecontroller.text = user.employer.company_name;
            // namecontroller.text = user.employer.company_name;
            // regcontroller.text = user.employer.reg_number;
            // sector = user.employer.sector_name;
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
                        "https://zumajob.herokuapp.com${user.employer.logo}"),
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
                        ? Text('Upload Company Logo',
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
              child: Text("${user.employer.email}",
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
              child: Text("Company Name",
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
              // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: namecontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: user.employer.company_name),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Company Address",
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
              // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: addresscontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: user.employer.company_address),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Company Registration Number",
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
              // width: 120,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: regcontroller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: user.employer.reg_number),
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
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    hintText: user.employer.phone),
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
              items: sectorlist,
              selectedItem: sector,
              label: "Select Company Sector",
              onChanged: (String item) {
                setState(() {
                  sector = item;
                  // print(level);
                });
              },
              // maxHeight: 45,
            ),
          ),
          Column(
            children: [
              Container(
                  height: 100,
                  width: 100,
                  child: cert == null
                      ? Icon(CupertinoIcons.book, size: 20)
                      : Text(path.basename(cert.path))),
              Container(
                // width: 100,
                height: 36,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: RaisedButton(
                  child: Text(
                    "Upload Company Certificate",
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
          SizedBox(height: 50)
        ],
      ),
    );
  }

  post_user(context, File imageFile, File cert) async {
    var uri = Uri.parse("https://zumajob.herokuapp.com/api/postprofile");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    // open a bytestream
    var stream,
        length,
        certstream,
        certlength,
        certmultipartFile,
        multipartFile;

    if (imageFile != null) {
      stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      length = await imageFile.length();

      multipartFile = new http.MultipartFile('logo', stream, length,
          filename: path.basename(imageFile.path));

      request.files.add(multipartFile);
    } else {
      request.fields['logo'] = "";
    }

    if (cert != null) {
      certstream = new http.ByteStream(DelegatingStream.typed(cert.openRead()));
      // get file length
      certlength = await cert.length();

      certmultipartFile = new http.MultipartFile('cert', certstream, certlength,
          filename: path.basename(cert.path));

      request.files.add(certmultipartFile);
    } else {
      request.fields['cert'] = "";
    }

    // string to uri

    request.fields['key'] = key;
    request.fields['phone'] = pcontroller.text;
    request.fields['company_name'] = namecontroller.text;
    request.fields['reg_number'] = regcontroller.text;
    request.fields['company_address'] = addresscontroller.text;
    request.fields['first_name'] = fcontroller.text;
    request.fields['last_name'] = lcontroller.text;
    request.fields['sector'] = sector;

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, textDirection: TextDirection.ltr);
    pr.style(message: "Updating ...");
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
                  context, MaterialPageRoute(builder: (context) => EmpHome()));
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
      if (e.response != null) {
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
