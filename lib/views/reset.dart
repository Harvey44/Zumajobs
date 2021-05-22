import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/register_resp.dart';
import 'package:zumajobs/views/register.dart';
import 'package:zumajobs/views/type.dart';

class Reset extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,

        body: Reset_Form(),
      ),
    );
  }
}

class Reset_Form extends StatefulWidget {
  @override
  _Reset_FormState createState() => _Reset_FormState();
}

class _Reset_FormState extends State<Reset_Form> {
  bool is_checked = false;
  var state = 'Checkbox must be ckecked';

  void togglecheck(bool value) {
    if (is_checked == false) {
      setState(() {
        is_checked = true;
        state = 'Checked';
      });
    } else {
      setState(() {
        is_checked = false;
        state = 'Checked';
      });
    }
  }

  bool did = true;

  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height / 3;
    return BlocProvider(
      create: (context) => SubmissionErrorToFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc =
              BlocProvider.of<SubmissionErrorToFieldFormBloc>(context);

          return Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.white,
            // appBar: AppBar(title: Text('Submission Error to Field')),
            body: FormBlocListener<SubmissionErrorToFieldFormBloc, String,
                String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);

                reset(context, formBloc);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Password Reset Failed")));
              },
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              MaterialIcons.keyboard_backspace,
                              color: Colors.black,
                              size: 20,
                            )),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Image(
                              image: AssetImage('assets/images/logotext.jpg'),
                              height: 40,
                              width: 100),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                        child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => Noty(),
                              //   ),
                              // );
                            },
                            child: Icon(
                              Icons.help,
                              color: Colors.black,
                              size: 20,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        //  width: MediaQuery.of(context).size.width-15,
                        // height: MediaQuery.of(context).size.height/2+40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xffffffff),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x29000000), blurRadius: 38)
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text("Forgot Passsword",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Column(
                                  children: <Widget>[
                                    TextFieldBlocBuilder(
                                      textFieldBloc: formBloc.email,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Email Address',
                                        contentPadding: EdgeInsets.all(5.0),
                                        hintText: 'Enter Email Address',
                                        prefixIcon: Icon(Icons.email),
                                      ),
                                    ),

                                    Container(
                                      width: 200,
                                      height: 36,
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: RaisedButton(
                                        child: Text(
                                          "Reset",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        onPressed: () {
                                          formBloc.submit();
                                        },
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // side: BorderSide(color: Colors.)
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 25),

                                    //  SizedBox(height: 250),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(25.0),
                        width: 200,
                        // height: 40,
                        child: RaisedButton(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.green, fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          color: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.green,
                              )),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void reset(context, formBloc) async {
    String email = formBloc.email.value;

    try {
      final RegisterResp response =
          await Provider.of<ApiService>(context, listen: false).reset(email);

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("token", response.key);
      formBloc.emitSuccess();
    } on DioError catch (e) {
      formBloc.emitFailure();
      if (e.response != null) {
        formBloc.emitFailure();
        try {
          formBloc.email.addFieldError(e.response.data["non_field_errors"][0]);
          formBloc.password
              .addFieldError(e.response.data["non_field_errors"][0]);
        } catch (error) {}
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e);
    }
  }
}

class SubmissionErrorToFieldFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
      validators: [FieldBlocValidators.required, FieldBlocValidators.email]);

  SubmissionErrorToFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [email],
    );
  }

  @override
  void onSubmitting() async {}
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => Reset_Form())),
              icon: Icon(Icons.replay),
              label: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
