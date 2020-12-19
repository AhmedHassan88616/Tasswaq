import 'package:Tassawaq/Admin/uploadItems.dart';
import 'package:Tassawaq/Authentication/authenication.dart';
import 'package:Tassawaq/DialogBox/errorDialog.dart';
import 'package:Tassawaq/Widgets/customTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'Tasswaq',
          style: TextStyle(
              fontSize: 55.0, color: Colors.white, fontFamily: 'Signatra'),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIdTextEditingController =
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
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/admin.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: _adminIdTextEditingController,
                    isObsecure: false,
                    hintText: 'ID',
                  ),
                  CustomTextField(
                    data: Icons.person,
                    controller: _passwordTextEditingController,
                    isObsecure: true,
                    hintText: 'Password',
                  ),
                  SizedBox(height: 25.0,),
                  RaisedButton(
                    onPressed: () {
                      _adminIdTextEditingController.text.isNotEmpty &&
                              _passwordTextEditingController.text.isNotEmpty
                          ? _loginAdmin()
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
                    height: 20.0,
                  ),
                  FlatButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AuthenticScreen(),
                      ),
                    ),
                    icon: Icon(
                      Icons.nature_people,
                      color: Colors.pink,
                    ),
                    label: Text(
                      "I'm not admin",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),

                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loginAdmin() {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['id'] != _adminIdTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'your id is not correct',
              ),
            ),
          );
        } else if (result.data()['password'] !=
            _passwordTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'your password is not correct',
              ),
            ),
          );
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome Dear Admin ' + result.data()['name']),
            ),
          );
          setState(() {
            _adminIdTextEditingController.text = "";
            _passwordTextEditingController.text = '';
          });
          Route route = MaterialPageRoute(builder: (_) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
