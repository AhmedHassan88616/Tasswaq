import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Models/item.dart';
import 'package:Tassawaq/Store/storehome.dart';
import 'package:Tassawaq/Widgets/customAppBar.dart';
import 'package:Tassawaq/Widgets/customTextField.dart';
import 'package:Tassawaq/Widgets/loadingWidget.dart';
import 'package:Tassawaq/Widgets/myDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchService {}

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  String shortInfo = "";
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchDelegate(searchOnProduct),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: (shortInfo != "" && shortInfo != null)
                  ? FirebaseFirestore.instance
                      .collection("items")
                      .where("shortInfo", whereIn: [shortInfo])
                      .limit(10)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("items")
                      .limit(15)
                      .orderBy("publishedDate", descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          ItemModel itemModel = ItemModel.fromJson(
                              snapshot.data.docs[index].data());
                          return sourceInfo(itemModel, context);
                        },
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  void searchOnProduct(String productShotInfo) {
    setState(() {
      shortInfo = productShotInfo;
    });
  }
}

Widget buildResultCard(data) {
  return Card();
}

class SearchDelegate extends SliverPersistentHeaderDelegate {
  Function function;

  SearchDelegate(this.function);

  final TextEditingController _searchTextEditingController =
      new TextEditingController();

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        child: InkWell(
          onTap: () {
            if (_searchTextEditingController.text.isNotEmpty)
              function(_searchTextEditingController.text);
            _searchTextEditingController.clear();
          },
          child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _searchTextEditingController,
                      decoration:
                          InputDecoration(hintText: "Search products here..."),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
