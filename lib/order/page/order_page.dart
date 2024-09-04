import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget{
  const OrderPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _OrderPageState();
  }
}

class _OrderPageState extends State<OrderPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单页面"),
      ),
    );
  }

}