import 'package:Tassawaq/Admin/adminLogin.dart';
import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/DialogBox/errorDialog.dart';
import 'package:Tassawaq/DialogBox/loadingDialog.dart';
import 'package:Tassawaq/Widgets/customTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'dart:developer';

import '../test.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      new TextEditingController();
  final TextEditingController _passwordTextEditingController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/login.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'LogIn to your account.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.email,
                    controller: _emailTextEditingController,
                    isObsecure: false,
                    hintText: 'Email',
                  ),
                  CustomTextField(
                    data: Icons.person,
                    controller: _passwordTextEditingController,
                    isObsecure: true,
                    hintText: 'Password',
                  ),
                  RaisedButton(
                    onPressed: () {
                      _emailTextEditingController.text.isNotEmpty &&
                              _passwordTextEditingController.text.isNotEmpty
                          ? _loginUser()
                          : showDialog(
                              context: context,
                              builder: (c) {
                                return ErrorAlertDialog(
                                  message: 'Please write email and password',
                                );
                              });
                    },
                    color: Colors.pink,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  FlatButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AdminSignInPage(),
                      ),
                    ),
                    icon: Icon(
                      Icons.nature_people,
                      color: Colors.pink,
                    ),
                    label: Text(
                      "I'm admin",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please wait.",
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: error.toString(),
          );
        },
      );
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  List<String> cartList;

  Future<void> readData(User fUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userUID, dataSnapshot.data()[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data()[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data()[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data()[EcommerceApp.userAvatarUrl]);
      cartList = List.from(dataSnapshot.data()[EcommerceApp.userCartList]);
      // print(cartList);
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
