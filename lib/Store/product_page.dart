import 'package:Tassawaq/Models/item.dart';
import 'package:Tassawaq/Store/storehome.dart';
import 'package:Tassawaq/Widgets/customAppBar.dart';
import 'package:Tassawaq/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  ItemModel itemModel;

  ProductPage(this.itemModel);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              width: screenSize.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[320],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemModel.longDescription,
                            style: largeTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            r"$ " + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () => checkItemInCart(
                            widget.itemModel.shortInfo, context),
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
                          width: screenSize.width - 40.0,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Add to cart',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
