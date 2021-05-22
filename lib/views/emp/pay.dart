import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/model_resp.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  int amount;
  String encryptionKey = "d9e9d5d961970d8bf7b75b6e";
  String publicKey = "FLWPUBK-f994141084671a0e0b40fe387e57527c-X";
  String key, name, email;

  @override
  void initState() {
    super.initState();
    get_amount();
    getKey();
  }

  get_amount() async {
    Map resp = {"key": key};
    var token = json.encode(resp);
    try {
      final ModelResp response =
          await Provider.of<ApiService>(context, listen: false)
              .get_extra(token);
      if (response.message == "Success") {
        setState(() {
          amount = response.amount;
          email = response.email;
          name = response.name;
        });
      } else {}
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        print(e.message);
      }
    }
  }

  getKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      key = preferences.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 100,
        height: 36,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
        child: RaisedButton(
          child: Text(
            "Pay Now",
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
          onPressed: () {
            beginPayment(context);
          },
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Colors.green,
              )),
        ),
      ),
    ));
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  beginPayment(context) async {
    String txref = _getReference();
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
        context: this.context,
        encryptionKey: encryptionKey,
        publicKey: publicKey,
        currency: 'USD',
        amount: "0.1",
        email: 'vronaldvic@gmail.com',
        fullName: 'Zumajobs',
        txRef: txref,
        isDebugMode: false,
        phoneNumber: "0123456789",
        acceptCardPayment: true,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: false,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: false,
        acceptUgandaPayment: false,
        acceptZambiaPayment: false);

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response, txref);
        if (isSuccessful) {
          // provide value to customer
          postpay(context);
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
      // print(stacktrace);
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response, txref) {
    return response.data.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data.currency == 'USD' &&
        response.data.amount == '0.1' &&
        response.data.txRef == txref;
  }

  postpay(context) async {
    Map resp = {"key": key};
    var token = json.encode(resp);

    try {
      final ModelResp response =
          await Provider.of<ApiService>(context, listen: false).post_pay(token);
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
