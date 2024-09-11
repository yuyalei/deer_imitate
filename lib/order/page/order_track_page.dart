import 'package:deer_imitate/res/dimens.dart';
import 'package:deer_imitate/widgets/my_app_bar.dart';
import 'package:deer_imitate/widgets/my_scroll_view.dart';
import 'package:flutter/material.dart';

import '../../res/gaps.dart';

class OrderTrackPage extends StatefulWidget{
  const OrderTrackPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OrderTrackPageState();
  }
}

final List<String> _titleList = ['订单已完成', '开始配送', '等待配送', '收到新订单'];
final List<String> _timeList = ['2019/08/30 13:30', '2019/08/30 11:30', '2019/08/30 9:30', '2019/08/30 9:00'];

class _OrderTrackPageState extends State<OrderTrackPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: '订单追踪',
      ),
      body: MyScrollView(
          children: [
            Padding(padding: EdgeInsets.only(top: 21.0,left: 16.0),
              child: Row(
                children: [
                  Text('订单编号: '),
                  Semantics(
                    label: '长按复制订单编号',
                    child: SelectableText('333333334',maxLines: 1,),
                  )
                ],
              ),
            ),
            Stepper(
              physics: const BouncingScrollPhysics(),
              currentStep: 4 - 1,
              controlsBuilder: (_, __) {
                return Gaps.empty; //操作按钮置空
              },
              steps:List.generate(4, (i) => _buildStep(i)),
            )
          ]
      )
    );
  }

  Step _buildStep(int index){
    final Color primaryColor = Theme.of(context).primaryColor;
    return Step(
        title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
          child: Text(_titleList[index],style: index ==0 ? TextStyle(fontSize: Dimens.font_sp14
          ,color: primaryColor):Theme.of(context).textTheme.bodyMedium,),
        ),
        subtitle: Text(_timeList[index], style: index == 0 ? TextStyle(
          fontSize: Dimens.font_sp12,
          color: primaryColor,
        ) : Theme.of(context).textTheme.titleSmall),
        content: const Text(''),
      isActive: index == 0,
      state: index == 0? StepState.complete : StepState.indexed
    );
  }
}