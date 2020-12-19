import 'dart:io';
import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/DialogBox/errorDialog.dart';
import 'package:Tassawaq/DialogBox/loadingDialog.dart';
import 'package:Tassawaq/Widgets/customTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      new TextEditingController();
  final TextEditingController _emailTextEditingController =
      new TextEditingController();
  final TextEditingController _passwordTextEditingController =
      new TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _userImageUrl = '';
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: _nameTextEditingController,
                    isObsecure: false,
                    hintText: 'Name',
                  ),
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
                  CustomTextField(
                    data: Icons.person,
                    controller: _cPasswordTextEditingController,
                    isObsecure: true,
                    hintText: 'Confirm Password',
                  ),
                  RaisedButton(
                    onPressed: () {
                      _uploadAndSaveImage();
                    },
                    color: Colors.pink,
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<void> _uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: 'Please Select An Image...',
            );
          });
    } else {
      _passwordTextEditingController.text ==
              _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cPasswordTextEditingController.text.isNotEmpty
              ? _uploadToStorage()
              : displayDialogue("Please write the registration complete form..")
          : displayDialogue("Password do not match.");
    }
  }

  void displayDialogue(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  _uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: 'Registering, Please wait.....');
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask uploadTask = storageReference.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      _userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
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
      saveUserInfoToFirestore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future<void> saveUserInfoToFirestore(User fUser) async {
    FirebaseFirestore.instance.collection('users').doc(fUser.uid).set({
      'uid': fUser.uid,
      'name': _nameTextEditingController.text.trim(),
      'email': _emailTextEditingController.text.trim(),
      'url': _userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });

    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, fUser.uid);
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userEmail, _emailTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, _userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
