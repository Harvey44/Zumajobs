import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/vacancy_resp.dart';

class Search extends StatefulWidget {
  String query;
  Search({
    Key key,
    this.query,
  });
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String key;

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
                child: Text("Job Vacancies",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
            Expanded(flex: 4, child: _buildVacancy(context)),
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildVacancy(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    Map resp = {"key": key, "query": widget.query};
    var data = json.encode(resp);
    var h = MediaQuery.of(context).size.height / 3;
    return FutureBuilder<VacancyResp>(
        future: Provider.of<ApiService>(context, listen: false).find_vac(data),
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
            return Column(
              children: [
                SizedBox(height: 20),
                ProfileShimmer(
                  hasBottomLines: true,
                ),
                SizedBox(height: 20),
                ProfileShimmer(
                  hasBottomLines: true,
                ),
              ],
            );
          }
        });
  }

  View(context, VacancyResp vacancy) {
    if (vacancy.vacancy.length == 0) {
      return Center(child: Text("No Result matching query"));
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
                        padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
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
                          padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                          child: Text(vacancy.vacancy[index].position,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                          child: Text(
                            "vacancy.vacancy[index].company",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
}
