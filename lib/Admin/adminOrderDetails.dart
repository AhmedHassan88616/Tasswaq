import 'package:Tassawaq/Admin/uploadItems.dart';
import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Orders/OrderDetailsPage.dart';
import 'package:Tassawaq/Widgets/customAppBar.dart';
import 'package:Tassawaq/Widgets/loadingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AdminOrderDetails extends StatelessWidget {
String orderId;
AdminOrderDetails({this.orderId});
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: EcommerceApp.firestore.collection(EcommerceApp.collectionOrders).doc(orderId).snapshots(),
              builder: (ctx,snapshot){
                return(snapshot.hasData && snapshot.data.data()!=null)?
                Column(
                  children: [
                    Text(
                      r" $ " +
                          snapshot.data.data()["totalAmount"].toString(),
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Order Id :\n" + orderId,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore
                          .collection("items")
                          .where(
                        "shortInfo",
                        whereIn: snapshot.data.data()["productIDs"],
                      )
                          .get(),
                      builder: (ctx, snap) {
                        return snap.hasData
                            ? Column(
                          children: [
                            orderDetails(
                              itemCount: snap.data.docs.length,
                              data: snap.data.docs,
                              orderId: orderId,
                              context: context,
                            ),
                          ],
                        )
                            : Center(
                          child: circularProgress(),
                        );
                      },
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                          .collection("userAddress")
                          .doc(snapshot.data.data()["addressID"])
                          .get(),
                      builder: (ctx, snap) {
                        return snap.hasData
                            ? Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              "Shipment Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("Name : " +
                                snap.data.data()["name"]),
                            Text("State : " +
                                snap.data.data()["state"]),
                            Text("City : " +
                                snap.data.data()["city"]),
                            Text("Phone Number : " +
                                snap.data.data()["phoneNumber"]),
                            Text("Flat Number : " +
                                snap.data.data()["flatNumber"]),
                            Text("Pin Code : " +
                                snap.data.data()["pincode"]),
                          ],
                        )
                            : Center(
                          child: circularProgress(),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            await EcommerceApp.firestore
                                .collection(EcommerceApp.collectionOrders)
                                .doc(orderId)
                                .delete()
                                .then((value) {
                              Route route = MaterialPageRoute(
                                  builder: (_) => UploadPage());
                              Navigator.pushReplacement(context, route);
                            });
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                colors: [
                                  Colors.pink,
                                  Colors.lightGreenAccent
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            width:
                            MediaQuery.of(context).size.width - 40.0,
                            height: 50,
                            child: Center(
                              child: Text(
                                'Confirm Placement',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ):Center(
                  child: circularProgress(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

class PaymentDetailsCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

class ShippingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
    );
  }

}


class KeyText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
