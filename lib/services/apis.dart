import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'models/customer_model.dart';
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

  Future<List<ProductsModel>> getSearchProducts(search) async {
    String url = URL + "products/?search_query=$search";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body)["data"] as List)
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

  Future<List<CustomersModel>> getCustomers() async {
    String url = URL + "customers";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body)["data"] as List)
            .map((e) => CustomersModel.fromJson(e))
            .toList();
        return data;
      } else
        throw "Something";
    } catch (e) {
      print(e.toString());
    }
    throw "Something";
  }

  Future<List<CustomersModel>> updateCustomer(CustomersModel model) async {
    String url = URL + "customers/?id=${model.id}";
    final uri = Uri.parse(url);
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, String> body = {
      "name": model.name,
      "mobile_number": model.mobile_number,
      "email": model.email,
      "street": model.street,
      "street_two": model.street_two,
      "city": model.city,
      "pincode": model.pincode.toString(),
      "country": model.country,
      "state": model.state.toString(),
    };
    final response =
        await http.put(uri, headers: headers, body: jsonEncode(body));
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body)["data"] as List)
            .map((e) => CustomersModel.fromJson(e))
            .toList();
        return data;
      } else
        throw "Something";
    } catch (e) {
      print(e.toString());
    }
    throw "Something";
  }

  Future<List<CustomersModel>> addCustomer(CustomersModel model) async {
    String url = URL + "customers/";
    final uri = Uri.parse(url);
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, String> body = {
      "name": model.name,
      "mobile_number": model.mobile_number,
      "email": model.email,
      "street": model.street,
      "street_two": model.street_two,
      "city": model.city,
      "pincode": model.pincode.toString(),
      "country": model.country,
      "state": model.state.toString(),
    };
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body)["data"] as List)
            .map((e) => CustomersModel.fromJson(e))
            .toList();
        return data;
      } else
        throw "Something";
    } catch (e) {
      print(e.toString());
    }
    throw "Something";
  }

  Future<List<CustomersModel>> searchCustomer(String search) async {
    String url = URL + "customers/?search_query=$search";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body)["data"] as List)
            .map((e) => CustomersModel.fromJson(e))
            .toList();
        return data;
      } else
        throw "Something";
    } catch (e) {
      print(e.toString());
    }
    throw "Something";
  }

  Future<int> placeOrder(data,amount,context) async {
    String url = URL + "orders/";
    final uri = Uri.parse(url);
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? cust = await prefs.getInt("custId");
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    List products = [];
    for (int i = 0; i < data.length; i++) {
      products.add({
        "product_id": data[i]["id"],
        "quantity": data[i]["qty"],
        "price": data[i]["price"],
      });
    }
    final Map<String, dynamic> body = {
      "customer_id": cust,
      "total_price": amount,
      "products": products,
    };
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
      print("response: ${response.statusCode},${response.body}");
      print("body: $body");
    try {
      if (response.statusCode == 200) {
        // var data = (jsonDecode(response.body)["data"] as List)
        //     .map((e) => CustomersModel.fromJson(e))
        //     .toList();
        box.clear();
        apis.clear();
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text(
                "Order Placed Successfully",
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print(response.statusCode);
        return response.statusCode;
      } else{

        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed'),
              content:  Text(
                "Failed To Place Previous Order",
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
        throw response.statusCode;
    } catch (e) {
      print(e.toString());
    }
    throw response.statusCode;
  }
}
