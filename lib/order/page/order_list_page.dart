import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatefulWidget {

  const OrderListPage({
    super.key,
    required this.index,
  });

  final int index;
  
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第${widget.index}個"),
      ),
      body: Center(
        child: Text("第${widget.index}個"),
      ),
    );
  }


  
  @override
  bool get wantKeepAlive => true;
}
