import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/sector_resp.dart';
import 'package:zumajobs/views/applicants.dart';
import 'package:zumajobs/views/intro.dart';

class Sector extends StatefulWidget {
  @override
  _SectorState createState() => _SectorState();
}

class _SectorState extends State<Sector> {
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
                child: Text("Job Sectors",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
            Expanded(flex: 4, child: _buildSectors(context)),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildSectors(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService

    Map resp = {"key": key};
    var token = json.encode(resp);
    var h = MediaQuery.of(context).size.height / 3;
    return FutureBuilder<SectorResp>(
        future:
            Provider.of<ApiService>(context, listen: false).get_sector(token),
        builder: (BuildContext context, AsyncSnapshot<SectorResp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Something wrong"),
                ),
              );
            }
            SectorResp sector = snapshot.data;
            return View(context, sector);
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

  View(context, SectorResp sector) {
    if (sector.sector.length == 0) {
      return Center(child: Text("Items"));
    } else {
      return Container(
        color: const Color(0x0d3049ba),
        child: Sectors(context, sector),
        // margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        // height: 200,..
      );
    }
  }

  GridView Sectors(context, SectorResp sector) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: sector.sector.length,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      itemBuilder: (context, int index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => Applicants(id: sector.sector[index].id)));
          },
          child: Container(
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CachedNetworkImage(
                        width: 40,
                        height: 40,
                        imageUrl:
                            "https://zumajob.herokuapp.com${sector.sector[index].image}",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(CupertinoIcons.info_circle)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0x0d3049ba),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(sector.sector[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
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
}
