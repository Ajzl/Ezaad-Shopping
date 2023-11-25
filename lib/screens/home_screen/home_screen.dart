import 'package:ezad_shopping/baseview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/products_provider.dart';
import '../cart/cart_main_screen.dart';
import '../products/products_main_screen.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProductsProvider>(context,listen: false).fetchProducts();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductsProvider>(context);
    List<Widget> _widgetOptions = <Widget>[
      Product_Screen(),
      Cart_Main_Screen(),

    ];
    return BaseView(
      endDrawer: Home_Drawer(),
      appbar: AppBar(
              elevation: 1,
              iconTheme: IconThemeData(
                color: Colors.black,
                size: 40,
              ),
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/man_person.png")),
              ),
              //
            ),
      body: _widgetOptions
          .elementAt(Provider.of<ProductsProvider>(context).selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF002D80),
          unselectedItemColor: Colors.indigo,
          currentIndex: Provider.of<ProductsProvider>(context).selectedIndex,
          onTap: (index) {
            index == 0
                ? productProvider.toggleHome()
                : productProvider.toggleCart();

          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: "Cart"),

          ]),
    );
  }
}

class Home_Drawer extends StatefulWidget {
  const Home_Drawer({Key? key}) : super(key: key);

  @override
  State<Home_Drawer> createState() => _Home_DrawerState();
}

class _Home_DrawerState extends State<Home_Drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(.7),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/logo.png"),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            tileColor: Color(0xFF002D80).withOpacity(.7),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
            },
            leading: Icon(
              Icons.person,
              size: 35,
              color: Colors.white,
            ),
            title: Text("Profile",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            tileColor: Color(0xFF002D80).withOpacity(.7),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings_Screen()));
            },
            leading: Icon(
              Icons.settings,
              size: 35,
              color: Colors.white,
            ),
            title: Text("Settings",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            tileColor: Color(0xFF002D80).withOpacity(.7),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              // Navigator.pushAndRemoveUntil(context,
              // MaterialPageRoute(builder: (context)=>MyHomePage()), (route) => false);
            },
            leading: Icon(
              Icons.logout,
              size: 35,
              color: Colors.white,
            ),
            title: Text("LogOut",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
        ],
      ),
    );
  }
}
