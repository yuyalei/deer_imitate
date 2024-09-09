import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../res/styles.dart';

class GoodsDeleteBottomSheet extends StatelessWidget{
  const GoodsDeleteBottomSheet({
    super.key,
    required this.onTapDelete,
  });

  final VoidCallback onTapDelete;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 52.0,
                child: Container(
                  child: Center(
                    child: Text('是否确认删除，防止错误操作',
                      style: TextStyles.textSize16,),
                  ),
                ),
              ),
              Gaps.line,
              MyButton(
                  minHeight: 54.0,
                  textColor: Theme.of(context).colorScheme.error,
                  text: '确认删除',
                  backgroundColor: Colors.transparent,
                  onPressed: (){
                    NavigatorUtils.goBack(context);
                    onTapDelete();
                  }
              ),
              Gaps.line,
              MyButton(
                minHeight: 54.0,
                textColor: Colours.text_gray,
                text: '取消',
                backgroundColor: Colors.transparent,
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
              ),
            ],
          )
      ),
    );
  }

}