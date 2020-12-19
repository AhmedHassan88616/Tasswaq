import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Models/address.dart';
import 'package:Tassawaq/Store/storehome.dart';
import 'package:Tassawaq/Widgets/customAppBar.dart';
import 'package:Tassawaq/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (formKey.currentState.validate()) {
              final addressModel = AddressModel(
                name: cName.text.trim(),
                phoneNumber: cPhoneNumber.text.trim(),
                flatNumber: cFlatHomeNumber.text.trim(),
                city: cCity.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text.trim(),
              ).toJson();
              // add to Firestore
              await EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(DateTime.now().toString())
                  .set(addressModel).then((value){
                   final snak=SnackBar(content: Text("New Address Added successfully."),);
                   scaffoldKey.currentState.showSnackBar(snak);
                   FocusScope.of(context).requestFocus(FocusNode());
                   formKey.currentState.reset();
              });
            }
            Route route = MaterialPageRoute(builder: (_) => StoreHome());
            Navigator.pushReplacement(context, route);
          },
          label: Text("Done"),
          icon: Icon(Icons.check),
          backgroundColor: Colors.pink,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      textEditingController: cName,
                    ),
                    MyTextField(
                      hint: "PhoneNumber",
                      textEditingController: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "FlatHomeNumber",
                      textEditingController: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      textEditingController: cCity,
                    ),
                    MyTextField(
                      hint: "State",
                      textEditingController: cState,
                    ),
                    MyTextField(
                      hint: "PinCode",
                      textEditingController: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;

  MyTextField({Key key, this.hint, this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field can not be empty" : null,
      ),
    );
  }
}
