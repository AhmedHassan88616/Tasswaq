import 'package:Tassawaq/Address/address.dart';
import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Counters/cartitemcounter.dart';
import 'package:Tassawaq/Counters/totalMoney.dart';
import 'package:Tassawaq/Models/item.dart';
import 'package:Tassawaq/Store/storehome.dart';
import 'package:Tassawaq/Widgets/customAppBar.dart';
import 'package:Tassawaq/Widgets/loadingWidget.dart';
import 'package:Tassawaq/Widgets/myDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context,listen: false).displayResult(totalAmount);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Cart is empty.");
          } else {
            Route route = MaterialPageRoute(
              builder: (_) => Address(
                totalAmount: totalAmount,
              ),
            );
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("check Out"),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            r"Total Price $ " +
                                amountProvider.totalAmount.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("items")
                .where(
                  "shortInfo",
                  whereIn: EcommerceApp.sharedPreferences
                      .getStringList(EcommerceApp.userCartList),
                )
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.docs.length == 0
                      ? beginBuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel itemModel = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());
                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = itemModel.price + totalAmount;
                              } else {
                                totalAmount += itemModel.price;
                              }
                              if (snapshot.data.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,listen: false)
                                      .displayResult(totalAmount);
                                });
                              }
                              return sourceInfo(itemModel, context,
                                  removeCartFunction: () =>
                                      removeItemFromUserCart(
                                          itemModel.shortInfo));
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.docs.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text("Cart is empty"),
              Text("Start adding items to cart"),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsID) async {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsID);
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({EcommerceApp.userCartList: tempCartList}).then(
      (value) async {
        Fluttertoast.showToast(msg: "Item Removed From Cart successfully.");
        await EcommerceApp.sharedPreferences
            .setStringList(EcommerceApp.userCartList, tempCartList);
        Provider.of<CartItemCounter>(context, listen: false).displayResult();
      },
    );
    setState(() {
      totalAmount = 0;
    });
  }
}
