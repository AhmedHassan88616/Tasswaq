import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Models/item.dart';
import 'package:Tassawaq/Widgets/customAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import 'adminOrderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders)
                .snapshots(),
            builder: (ctx, snapshot) {
              return (snapshot.hasData && snapshot.data.docs != null)
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (ctx, index) {
                        return FutureBuilder<QuerySnapshot>(
                          future: EcommerceApp.firestore
                              .collection("items")
                              .where("shortInfo",
                                  whereIn: snapshot.data.docs[index]
                                      .data()["productIDs"])
                              .get(),
                          builder: (ctx, snap) {
                            return (snap.hasData && snap.data.docs != null)
                                ? AdminOrderCard(snap.data.docs,snapshot.data.docs[index].id)
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        );
                      },
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
