import 'package:Tassawaq/Models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Store/storehome.dart';
import 'adminOrderDetails.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  List<QueryDocumentSnapshot> documentList;
  String orderId;

  AdminOrderCard(this.documentList, this.orderId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: documentList.length * 190.0,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: documentList.length,
          itemBuilder: (ctx, index) {
            ItemModel itemModel =
                ItemModel.fromJson(documentList[index].data());
            return sourceInfo(itemModel, context);
          },
        ),
      ),
      onTap: () {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (ctx) => AdminOrderDetails(orderId: orderId));
        Navigator.push(context, route);
      },
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, {Color background}) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      color: Colors.grey[100],
      height: 170.0,
      width: width,
      child: Row(
        children: [
          Image.network(model.thumbnailUrl),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.title,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          r"$" + model.price.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
