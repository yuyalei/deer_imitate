import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {

  const ShopPage({
    super.key
  });


  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商店页面"),
      ),
    );
  }
}