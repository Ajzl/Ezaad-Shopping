import 'package:ezad_shopping/baseview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../provider/products_provider.dart';

class Product_Screen extends StatefulWidget {
  const Product_Screen({Key? key}) : super(key: key);

  @override
  State<Product_Screen> createState() => _Product_ScreenState();
}

class _Product_ScreenState extends State<Product_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    box.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productlist = Provider.of<ProductsProvider>(context)?.products;
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Please use Bottom Navigation or Back button on the AppBar")));
        return false;
      },
      child: BaseView(
          body: productlist == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 48,
                        width: MediaQuery.of(context).size.width * .95,
                        child: SearchBar(
                            onChanged: (val) {
                              Provider.of<ProductsProvider>(context,
                                      listen: false)
                                  .getSearchProducts(val);
                            },
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                            elevation: MaterialStateProperty.all(1),
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.grey)),
                            hintText: "Search",
                            hintStyle: MaterialStateProperty.all(
                                TextStyle(color: Colors.grey)),
                            trailing: [
                              GestureDetector(
                                  onTap: () async {
                                    var result = await box.values.toList();
                                    print(result);
                                  },
                                  child: Container(
                                      height: 48,
                                      width: 30,
                                      child: Icon(
                                        Icons.qr_code,
                                        color: Colors.grey,
                                        size: 28,
                                      ))),
                              SizedBox(
                                width: 4,
                              ),
                            ]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1 / 1.1),
                            itemCount: productlist?.length,
                            itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${productlist?[index].image}")),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                7.5),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 75,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${productlist?[index].name[0].toUpperCase()}${productlist?[index].name.substring(1)}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "\$${productlist?[index].price.toString()}/-",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "|",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(
                                                height: 28,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xFF002D82))),
                                                    onPressed: () {
                                                      box.put(
                                                          productlist?[index]
                                                              .id,
                                                          {"image":
                                                          productlist?[
                                                          index]
                                                              .image,
                                                            "name":
                                                                productlist?[
                                                                        index]
                                                                    .name,
                                                            "id": productlist?[
                                                                    index]
                                                                .id,
                                                            "price":
                                                                productlist?[
                                                                        index]
                                                                    .price,
                                                            "qty": 1
                                                          });
                                                    },
                                                    child: Text("ADD")))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                      ),
                    ),
                  ],
                )),
    );
  }
}
