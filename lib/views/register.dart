import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zumajobs/Api/api_service.dart';
import 'package:zumajobs/models/register_resp.dart';
import 'package:zumajobs/views/login.dart';
import 'package:zumajobs/views/privacy.dart';
import 'package:zumajobs/views/type.dart';

class Register extends StatefulWidget {
  String type;
  Register({
    Key key,
    this.type,
  });
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

        body: Register_Form(type: widget.type),
      ),
    );
  }
}

class Register_Form extends StatefulWidget {
  String type;
  Register_Form({
    Key key,
    this.type,
  });
  @override
  _Register_FormState createState() => _Register_FormState();
}

class _Register_FormState extends State<Register_Form> {
  bool is_checked = false;
  var state = 'Checkbox must be ckecked';
  String country_selected = "Select Country";
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

                reg(context, formBloc);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => UserType()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Registration Failed")));
              },
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                              child: Text("Create an Account",
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
                                      textFieldBloc: formBloc.username,
                                      keyboardType: TextInputType.text,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9 a-z A-Z]'))
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        contentPadding: EdgeInsets.all(8.0),
                                        hintText: 'Enter Username',
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),

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

                                    TextFieldBlocBuilder(
                                      suffixButton: SuffixButton.obscureText,
                                      textFieldBloc: formBloc.password1,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        contentPadding: EdgeInsets.all(5.0),
                                        hintText: 'Enter Password',
                                        prefixIcon: Icon(Icons.lock),
                                      ),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 10),
                                      child: RaisedButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.home,
                                                color: Colors.grey),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                country_selected,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          showCountryPicker(
                                              context: context,
                                              showPhoneCode: false,
                                              onSelect: (Country country) {
                                                setState(() {
                                                  country_selected = country
                                                      .displayNameNoCountryCode;
                                                });
                                              });
                                        },
                                        color: Colors.grey[50],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                              color: Colors.grey,
                                            )),
                                      ),
                                    ),

                                    CheckboxListTile(
                                      value: is_checked,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        togglecheck(value);
                                      },
                                      checkColor: Colors.white,
                                      title: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) => Privacy()));
                                        },
                                        child: Text.rich(
                                          TextSpan(
                                              text: 'I agree to the ',
                                              style: TextStyle(fontSize: 12.0),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'Terms and Conditions and Privacy Policy.',
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        decoration:
                                                            TextDecoration
                                                                .underline))
                                              ]),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: 200,
                                      height: 36,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                      child: RaisedButton(
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (is_checked == false) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "You must agree to terms")));
                                            } else {
                                              formBloc.submit();
                                            }
                                          });
                                        },
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // side: BorderSide(color: Colors.)
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 5),

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
                            "Sign In",
                            style: TextStyle(color: Colors.green, fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
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

  void reg(context, formBloc) async {
    String username = formBloc.username.value;
    String email = formBloc.email.value;
    String type = widget.type;
    String password1 = formBloc.password1.value;
    String password2 = formBloc.password1.value;
    String country = country_selected;

    try {
      final RegisterResp response =
          await Provider.of<ApiService>(context, listen: false)
              .createUser(username, email, type, country, password1, password2);
      // Response response =
      //     await Dio().post("https://betadeals.herokuapp.com/auth/reg", data: {
      //   "username": username,
      //   "email": email,
      //   "ref_used": ref_used,
      //   "password1": password1,
      //   "password2": password2
      // });

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("token", response.key);
      pref.setString("username", username);
      pref.setInt("noty", 0);
      formBloc.emitSuccess();
    } on DioError catch (e) {
      formBloc.emitFailure();
      if (e.response != null) {
        formBloc.emitFailure();
        try {
          formBloc.username.addFieldError(e.response.data["username"][0]);
          formBloc.email.addFieldError(e.response.data["email"][0]);
          formBloc.ref_used.addFieldError(e.response.data["ref_used"]);
          formBloc.password1.addFieldError(e.response.data["password1"][0]);
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
  final username = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(
      validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  final password1 = TextFieldBloc(validators: [FieldBlocValidators.required]);

  SubmissionErrorToFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [username, email, password1],
    );
  }

  @override
  void onSubmitting() async {
    print(username.value);
  }
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
                  MaterialPageRoute(builder: (_) => Register_Form())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
