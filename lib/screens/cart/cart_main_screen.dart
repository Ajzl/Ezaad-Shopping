import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ezad_shopping/baseview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/cart_provider.dart';
import '../../provider/loader_provider.dart';
import '../../provider/products_provider.dart';
import '../home_screen/home_screen.dart';

class Cart_Main_Screen extends StatefulWidget {
  const Cart_Main_Screen({Key? key}) : super(key: key);

  @override
  State<Cart_Main_Screen> createState() => _Cart_Main_ScreenState();
}

class _Cart_Main_ScreenState extends State<Cart_Main_Screen> {
  var result;
  var subTotal = 0.0;
  late StreamSubscription connectivity;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<Cart_Provider>(context, listen: false).fetchCart(context);
    getBox();
    super.initState();
  }

  apiQueue(queuelist, context) async {
    for (int i = 0; i < queuelist.length; i++) {
      await Provider.of<Cart_Provider>(context, listen: false)
          .placeOrder(queuelist[i]["result"], queuelist[i]["total"], context);
    }
  }

  getBox() async {
    result = await box.values.toList();
    double Subtotal = 0;
    for (int i = 0; i < result.length; i++) {
      var subs = (result[i]["qty"] * result[i]["price"]);
      Subtotal = Subtotal + subs;
    }
    subTotal = Subtotal;
    print(Subtotal);
    print(result);
    connectivity = Connectivity().onConnectivityChanged.listen((event) async {
      if (mounted && event == ConnectivityResult.none) {
        Provider.of<Cart_Provider>(context, listen: false)
            .toggleconnection(false);
        print("no internet");
      } else if (mounted && event == ConnectivityResult.wifi) {
        Provider.of<Cart_Provider>(context, listen: false)
            .toggleconnection(true);
        var queuelist = await apis.values.toList();
        if (queuelist.length != 0)
          Future.delayed(Duration(seconds: 2), () async {
            await apiQueue(queuelist, context);
          });
        // setState(() {
        //   result= box.values.toList();
        // });
        print("on wifi");
      } else if (mounted && event == ConnectivityResult.mobile) {
        Provider.of<Cart_Provider>(context, listen: false)
            .toggleconnection(true);
        var queuelist = await apis.values.toList();
        if (queuelist.length != 0)
          Future.delayed(Duration(seconds: 2), () async {
            await apiQueue(queuelist, context);
          });
        setState(() {
          result = box.values.toList();
        });
        print("on mobile");
      } else if (event == ConnectivityResult.ethernet) {
        Provider.of<Cart_Provider>(context, listen: false)
            .toggleconnection(true);
        print("on ethernet");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart_Provider>(context);

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Please use Bottom Navigation or Back button on the AppBar")));
        return false;
      },
      child: BaseView(
          body: cartProvider.result?.length == 0 || cartProvider.result == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child:
                Image.asset("assets/svg/empty-cart.png", width: 300),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Cart is Empty",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              )
            ],
          )
              : Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: cartProvider.result.length,
                      itemBuilder: (context, index) =>
                          Dismissible(key:UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(color: Colors.red,),
                            onDismissed: (DismissDirection endToStart){
                              box.deleteAt(index);
                              cartProvider
                                  .fetchCart(context);
                              double Subtotal = 0;
                              result = box.values.toList();
                              for (int i = 0;
                              i < result.length;
                              i++) {
                                var subs = (result[i]
                                ["qty"] *
                                    result[i]["price"]);
                                Subtotal =
                                    Subtotal + subs;
                              }
                              setState(() {
                                subTotal = Subtotal;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0),
                              child: Container(
                                  height:
                                  MediaQuery.of(context).size.height /
                                      10,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.network(
                                              cartProvider.result[index]
                                              ["image"],
                                              width: 80,
                                              fit: BoxFit.cover),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: 120,
                                                child: Text(
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  cartProvider.result[index]
                                                  ["name"]
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "\$${cartProvider.result[index]["price"]}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  .22,
                                              child: InputQty(
                                                minVal: 1,
                                                onQtyChanged: (val) async {
                                                  await box.put(
                                                      result[index]["id"], {
                                                    "image": result[index]
                                                    ["image"],
                                                    "name": result[index]
                                                    ["name"],
                                                    "id": result[index]
                                                    ["id"],
                                                    "price": result[index]
                                                    ["price"],
                                                    "qty": val,
                                                  });
                                                 await cartProvider.fetchCart(context);

                                                  double Subtotal = 0;
                                                  for (int i = 0;
                                                  i < cartProvider.result.length;
                                                  i++) {
                                                    var subs = (cartProvider.result[i]
                                                    ["qty"] *
                                                        cartProvider.result[i]["price"]);
                                                    Subtotal =
                                                        Subtotal + subs;
                                                  }
                                                  setState(() {
                                                    subTotal = Subtotal;
                                                  });
                                                  print(Subtotal);
                                                },
                                                qtyFormProps: QtyFormProps(
                                                    enableTyping: false),
                                                decoration:
                                                QtyDecorationProps(
                                                  isBordered: true,
                                                  minusBtn: Icon(
                                                    Icons.remove,
                                                    color:
                                                    Color(0xFF002D80),
                                                  ),
                                                  plusBtn: Icon(Icons.add,
                                                      color: Color(
                                                          0xFF002D80)),
                                                ),
                                                initVal: cartProvider
                                                    .result[index]["qty"],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          )),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SubTotal ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "\$ $subTotal",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tax ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "\$ ${(subTotal) * (5 / 100)}",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 10,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$ ${subTotal + ((subTotal) * (5 / 100))}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width:
                              MediaQuery.of(context).size.width / 2.5,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Color(0xFF004D90)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  100)))),
                                  onPressed: () async {
                                    if (subTotal != 0) {
                                      if (cartProvider.isConnected ==
                                          true) {
                                        await cartProvider.placeOrder(
                                            result,
                                            subTotal +
                                                ((subTotal) * (5 / 100)),
                                            context);
                                      } else {
                                        await apis.put(
                                            Random().nextInt(9000), {
                                          "result": result,
                                          "total": subTotal +
                                              ((subTotal) * (5 / 100))
                                        });
                                        box.clear();
                                        var api =
                                        await apis.values.toList();
                                        showDialog<void>(
                                          barrierDismissible: false,
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Queue'),
                                              content: Text(
                                                "Your Order will Be Placed Once"
                                                    "Network gets Connected",
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    textStyle:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                    Provider.of<ProductsProvider>(
                                                        context,
                                                        listen: false)
                                                        .toggleHome();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        print(api);
                                      }
                                    } else
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              "Please add products to cart")));
                                  },
                                  child: Text(
                                    "Order",
                                    style: TextStyle(fontSize: 16),
                                  ))),
                          Container(
                              width:
                              MediaQuery.of(context).size.width / 2.5,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Color(0xFF004D90)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  100)))),
                                  onPressed: () {},
                                  child: Text("Order & Deliver",
                                      style: TextStyle(fontSize: 16)))),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
