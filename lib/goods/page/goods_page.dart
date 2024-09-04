import 'package:flutter/material.dart';

class GoodsPage extends StatefulWidget{
  const GoodsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GoodsPageState();
  }

}

class _GoodsPageState extends State<GoodsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text("商品页面")
      ),
    );
  }

}