import 'package:flutter/material.dart';

import '../../widgets/my_app_bar.dart';

class OrderInfoPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return _OrderInfoPageState();
  }

  const OrderInfoPage({super.key});
}

class _OrderInfoPageState extends State<OrderInfoPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actionName: '订单跟踪',
        onPressed: () {

        },
      ),
    );
  }

}