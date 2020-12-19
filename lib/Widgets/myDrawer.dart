import 'package:Tassawaq/Address/addAddress.dart';
import 'package:Tassawaq/Authentication/authenication.dart';
import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Orders/myOrders.dart';
import 'package:Tassawaq/Store/Search.dart';
import 'package:Tassawaq/Store/cart.dart';
import 'package:Tassawaq/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
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
              children: [
                Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(80.0),
                  ),
                  elevation: 8.0,
                  child: Container(
                    height: 140.0,
                    width: 140.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userAvatarUrl),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontFamily: 'Signatra'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
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
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (_) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 8.0,
                ),


                ListTile(
                  leading: Icon(Icons.reorder),
                  title: Text(
                    'My Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (_) => MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 8.0,
                ),


                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(
                    'My Carts',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (_) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 8.0,
                ),


                ListTile(
                  leading: Icon(Icons.search),
                  title: Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (_) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 8.0,
                ),


                ListTile(
                  leading: Icon(Icons.add_location),
                  title: Text(
                    'Add new address',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (_) => AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 8.0,
                ),


                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    EcommerceApp.auth.signOut().then((value) {
                      Route route =
                      MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });

                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 8.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
