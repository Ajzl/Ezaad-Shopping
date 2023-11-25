import 'package:ezad_shopping/provider/loader_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView extends StatefulWidget {
  final AppBar? appbar;
  final Widget body;
  final Widget? endDrawer;
  final Widget? drawer;
  final BottomNavigationBar? bottomNavigationBar;
  const BaseView({Key? key,
    this.appbar,
    required this.body,
    this.bottomNavigationBar,
    this.endDrawer,
    this.drawer,
  }) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: widget.appbar,
      body: Provider.of<Loader_Provider>(context,listen: false).isLoading==true?
      Center(child: CircularProgressIndicator()):widget.body,
    );
  }
}
