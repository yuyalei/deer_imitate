
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {

  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title:  Text("统计页面"),
      ),
    );
  }
}