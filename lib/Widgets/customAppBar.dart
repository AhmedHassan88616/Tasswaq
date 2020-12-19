import 'package:Tassawaq/Config/config.dart';
import 'package:Tassawaq/Counters/cartitemcounter.dart';
import 'package:Tassawaq/Store/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;

  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
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
        'Tasswaq',
        style: TextStyle(
            fontSize: 55.0, color: Colors.white, fontFamily: 'Signatra'),
      ),
      centerTitle: true,
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.pink,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (_) => CartPage());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 5.0,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                            (EcommerceApp.sharedPreferences
                              .getStringList(EcommerceApp.userCartList)
                              .length-1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
