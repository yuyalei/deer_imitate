import 'package:deer_imitate/widgets/base_dilaog.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/gaps.dart';

class PayTypeDialog extends StatefulWidget{
  final void Function(int,String)? onPressed;


  PayTypeDialog({super.key,this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return _PayTypeDialog();
  }
}

class _PayTypeDialog extends State<PayTypeDialog> {
  int _value = 0;
  final _list = ['未收款', '支付宝', '微信', '现金'];

  Widget _buildItem(int index){
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        child: SizedBox(
          height: 42.0,
          child: Row(
            children: [
              Gaps.hGap16,
              Expanded(
                child: Text(
                  _list[index],
                  style: _value == index ? TextStyle(
                    fontSize: Dimens.font_sp14,
                    color: Theme.of(context).primaryColor,
                  ) : null,
                ),
              ),
              Visibility(
                visible: _value == index,
                  child: const LoadAssetImage('order/ic_check', width: 16.0, height: 16.0),
              ),
              Gaps.hGap16,
            ],
          ),
        ),
        onTap: (){
          if(mounted){
            setState(() {
              _value = index;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
        title: '收款方式',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_list.length, (i) => _buildItem(i)),
        ),
      onPressed: (){widget.onPressed?.call(_value,_list[_value]);}
    );
  }
}