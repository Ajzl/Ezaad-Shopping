import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'loader_provider.dart';


class Cart_Provider extends ChangeNotifier{
  bool isConnected=true;
  int? response;
  var result;

  Future<void> fetchCart(context)async{
   await Provider.of<Loader_Provider>(context,listen: false).loadingAction(true);
    this.result= await box.values.toList();
    if(this.result!=null)
   await Provider.of<Loader_Provider>(context,listen: false).loadingAction(false);
    notifyListeners();
  }
  Future<void> placeOrder(result,amount,context)async{
    // this.response=await HttpServices().placeOrder(result,amount,context);
    if(response==200)
    print("response : ${this.response}");
    notifyListeners();
  }

  Future<void> toggleconnection(bool onNetwork)async{
    this.isConnected=onNetwork;
    notifyListeners();
  }
}