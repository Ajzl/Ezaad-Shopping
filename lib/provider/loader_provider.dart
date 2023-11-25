import 'package:flutter/cupertino.dart';

class Loader_Provider extends ChangeNotifier{
  bool isLoading=false;

  Future<void> loadingAction(loading)async {
    this.isLoading = loading;
  }
}