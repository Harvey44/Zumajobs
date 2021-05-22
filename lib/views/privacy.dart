import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/model_resp.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(MaterialIcons.keyboard_backspace,
                color: Colors.black, size: 18),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text("Privacy Policy",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        body: _buildBody(context));
  }

  FutureBuilder _buildBody(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService
    return FutureBuilder<ModelResp>(
        future: Provider.of<ApiService>(context, listen: false).get_privacy(),
        builder: (BuildContext context, AsyncSnapshot<ModelResp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("Something wrong"),
                ),
              );
            }
            final model = snapshot.data;

            return _buildPosts(context: context, model: model);
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  _buildPosts({BuildContext context, ModelResp model}) {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //  int subcount = preferences.getInt("subcount");

    if (model.message == "Request Success") {
      return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model.privacy,
                style: TextStyle(
                  fontSize: 16,
                ))),
      );
    }
  }
}
