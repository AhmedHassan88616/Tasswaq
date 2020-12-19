import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{
  double _totalAmount=0.0;
  double get totalAmount=>_totalAmount;

  displayResult(double n)async{
    _totalAmount=n;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}