import 'package:Tassawaq/Config/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            'My Orders',
            style: TextStyle(
                fontSize: 55.0, color: Colors.white, fontFamily: 'Signatra'),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .snapshots(),
          builder: (ctx, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: EcommerceApp.firestore
                            .collection("items")
                            .where("shortInfo",
                                whereIn: snapshot.data.docs[index]
                                    .data()[EcommerceApp.productID])
                            .get(),
                        builder: (ctx,snap){
                          return snap.hasData?OrderCard(
                            itemCount: snap.data.docs.length,
                            data: snap.data.docs,
                            orderId: snapshot.data.docs[index].id,
                          ):Center(child: circularProgress(),);
                        },
                      );
                    },
                  )
                : Center(child: circularProgress());
          },
        ),
      ),
    );
  }
}
