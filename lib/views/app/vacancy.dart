import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/model_resp.dart';
import 'package:zumajobs/models/vacancy_resp.dart';
import 'package:zumajobs/views/app/search.dart';

class Vacancy extends StatefulWidget {
  @override
  _VacancyState createState() => _VacancyState();
}

class _VacancyState extends State<Vacancy> {
  String key, remote;
  TextEditingController scontroller = TextEditingController();

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
                child: Text("Recommended Jobs",
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
                    hintText: "Search for a position, e.g App Developer",
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
            Expanded(flex: 4, child: _buildVacancy(context)),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildVacancy(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    Map resp = {"key": key};
    var token = json.encode(resp);
    var h = MediaQuery.of(context).size.height / 3;
    return FutureBuilder<VacancyResp>(
        future:
            Provider.of<ApiService>(context, listen: false).get_vacancy(token),
        builder: (BuildContext context, AsyncSnapshot<VacancyResp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Something wrong"),
                ),
              );
            }
            VacancyResp vacancy = snapshot.data;
            return View(context, vacancy);
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  View(context, VacancyResp vacancy) {
    if (vacancy.vacancy.length == 0) {
      return Center(child: Text("No Vacancies"));
    } else {
      return Container(
        color: const Color(0x0d3049ba),
        child: Vacancy(context, vacancy),
        // margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        // height: 200,..
      );
    }
  }

  ListView Vacancy(context, VacancyResp vacancy) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: vacancy.vacancy.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (_) => dish.Dish(id: home.dish[index].id)));
            showCupertinoModalBottomSheet(
                context: context,
                duration: Duration(seconds: 2),
                builder: (context) => BottomSheetView(context, vacancy, index));
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
                          backgroundImage: NetworkImage(
                              "https://zumajob.herokuapp.com${vacancy.vacancy[index].logo}"),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Text(vacancy.vacancy[index].position,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green)),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                        //   child: Text(
                        //     vacancy.vacancy[index].company,
                        //     style: TextStyle(
                        //         color: Colors.grey,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 12),
                        //   ),
                        // ),
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
                            child: Icon(CupertinoIcons.money_dollar_circle,
                                color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(vacancy.vacancy[index].salary,
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
                            child: Text(vacancy.vacancy[index].location,
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

  BottomSheetView(context, VacancyResp vacancy, index) {
    if (vacancy.vacancy[index].remote == true) {
      remote = "Remote Location or ${vacancy.vacancy[index].location}";
    } else {
      remote = "Non-Remote Job - ${vacancy.vacancy[index].location} only";
    }
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Center(
                    child: Text(vacancy.vacancy[index].company,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Center(
                    child: Text(vacancy.vacancy[index].location,
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Center(
                    child: Text(vacancy.vacancy[index].position,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Icon(CupertinoIcons.location, color: Colors.grey),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(remote,
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
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
                                    AssetImage("assets/images/work_icon.png")),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(vacancy.vacancy[index].duration),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
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
                                    AssetImage("assets/images/exp_icon.png")),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Text(vacancy.vacancy[index].experience),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
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
                            child: Image(
                                image:
                                    AssetImage("assets/images/pay_icon.png")),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                            child: Text(vacancy.vacancy[index].salary,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Job Description",
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
                    child: Text(vacancy.vacancy[index].description,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1.2)),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  postapply(context);
                  _sendMail(vacancy.vacancy[index].email,
                      vacancy.vacancy[index].position);
                },
                label: Text("Apply Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                backgroundColor: Colors.green),
          ),
        ));
  }

  _sendMail(email, position) async {
    var uri =
        'mailto:$email?subject=$position&body=Hi, From Zuma Jobs, Applying for the position of $position  ...';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Failed';
    }
  }

  postapply(context) async {
    Map resp = {"key": key};
    var token = json.encode(resp);

    try {
      final ModelResp response =
          await Provider.of<ApiService>(context, listen: false)
              .post_apply(token);
      if (response.message == "Success") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int v = preferences.getInt("apply");
        preferences.setInt("apply", v + 1);
      } else {}
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        print(e.message);
      }
    }
  }
}
