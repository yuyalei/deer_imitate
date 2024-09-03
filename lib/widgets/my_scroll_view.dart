import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class MyScrollView extends StatelessWidget{
  /// 注意：同时存在底部按钮与keyboardConfig配置时，为保证软键盘弹出高度正常。需要在`Scaffold`使用 `resizeToAvoidBottomInset: defaultTargetPlatform != TargetPlatform.iOS,`
  /// 除非Android与iOS平台均使用keyboard_actions
  const MyScrollView({
    super.key,
    required this.children,
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.bottomButton,
    this.keyboardConfig,
    this.tapOutsideToDismiss = false,
    this.overScroll = 16.0,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? bottomButton;
  final KeyboardActionsConfig? keyboardConfig;
  /// 键盘外部按下将其关闭
  final bool tapOutsideToDismiss;
  /// 默认弹起位置在TextField的文字下面，可以添加此属性继续向上滑动一段距离。用来露出完整的TextField。
  final double overScroll;

  @override
  Widget build(BuildContext context) {
    Widget contents = Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );

    contents = SingleChildScrollView(
      padding: padding,
      physics: physics,
      child: contents,
    );

    if(bottomButton != null){
      contents = Column(
        children: <Widget>[
          Expanded(child: contents),
          SafeArea(child: bottomButton!)
        ],
      );
    }

    return contents;
  }
  
}