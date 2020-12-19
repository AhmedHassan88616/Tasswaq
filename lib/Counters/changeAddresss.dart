
import 'package:Tassawaq/Admin/adminOrderCard.dart';
import 'package:flutter/foundation.dart';

class AddressChanger extends ChangeNotifier{
  int _counter=0;
  int get count=>_counter;

  displayResult(int n){
    _counter=n;
    notifyListeners();
  }
}