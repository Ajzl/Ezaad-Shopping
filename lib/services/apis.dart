import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'models/product_model.dart';
import 'package:http/http.dart' as http;

String URL = "http://62.72.44.247/api/";

class HttpServices {
  Future<List<ProductsModel>> getProducts() async {
    String url = "https://dummyjson.com/products";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body)["products"] as List)
            .map((e) => ProductsModel.fromJson(e))
            .toList();
        return data;
      } else
        throw "Something";
    } catch (e) {
      print(e.toString());
    }
    throw "Something";
  }


}
