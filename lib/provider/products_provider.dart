import 'package:flutter/cupertino.dart';
import '../services/apis.dart';
import '../services/models/product_model.dart';

class ProductsProvider extends ChangeNotifier{
  List<ProductsModel>? products;
  int selectedIndex = 0;


  Future<void> fetchProducts()async{
    this.products = await HttpServices().getProducts();
    notifyListeners();
  }

  Future<void> getSearchProducts(search)async{
    // this.products = await HttpServices().getSearchProducts(search);
    notifyListeners();
  }

  Future<void> toggleCart()async{
    this.selectedIndex=1;
    notifyListeners();
  }
  Future<void> toggleHome()async{
    this.selectedIndex=0;
    notifyListeners();
  }


}