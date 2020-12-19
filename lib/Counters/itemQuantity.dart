import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItem=0;

  int get numberOfItems=>_numberOfItem;
  display(int n){
    _numberOfItem=n;
    notifyListeners();
  }
}
