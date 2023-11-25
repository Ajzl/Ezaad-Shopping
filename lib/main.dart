
import 'package:ezad_shopping/provider/cart_provider.dart';
import 'package:ezad_shopping/provider/loader_provider.dart';
import 'package:ezad_shopping/provider/products_provider.dart';
import 'package:ezad_shopping/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

late final Box box;
late final Box apis;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("Boxes");
  await Hive.openBox('products_box');
  await Hive.openBox('api_calls');
  box= Hive.box('products_box');
  apis= Hive.box('api_calls');


  runApp(MultiProvider(providers: [
    ListenableProvider<ProductsProvider>(create: (_) => ProductsProvider()),
    ListenableProvider<Cart_Provider>(create: (_) => Cart_Provider()),
    ListenableProvider<Loader_Provider>(create: (_) => Loader_Provider()),
  ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
    debugShowCheckedModeBanner: false,
      home:  Home_Screen(),
    );
  }
}

