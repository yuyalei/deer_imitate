import 'package:deer_imitate/res/colors.dart';
import 'package:deer_imitate/res/dimens.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../res/gaps.dart';

class BaseDialog extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final Widget child;
  final bool hiddenTitle;

  BaseDialog(
      {this.title,
      this.onPressed,
      required this.child,
      this.hiddenTitle = false});

  @override
  Widget build(BuildContext context) {
    final Widget dialogTitle = Visibility(
        visible: !hiddenTitle,
        child: Text(
          hiddenTitle ? '' : title ?? '',
          style: TextStyle(
              fontSize: Dimens.font_sp18, fontWeight: FontWeight.bold),
        ));

    final Widget bottomButton = Row(
      children: [
        _DialogButton(
            text: '取消',
          textColor: Colours.text_gray,
          onPressed: () => NavigatorUtils.goBack(context),
        ),
        SizedBox(
          height: 48.0,
          width: 0.6,
          child: VerticalDivider(),
        ),
        _DialogButton(
          text: '确定',
          textColor: Theme.of(context).primaryColor,
          onPressed: onPressed,
        ),
      ],
    );

    final Widget content = Material(
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min ,
        children: [
          Gaps.vGap24,
          dialogTitle,
          Flexible(child: child),
          Gaps.vGap8,
          Gaps.line,
          bottomButton,
        ],
      ),
    );

    final Widget body = MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: SizedBox(
            width: 270.0,
            child: content,
          ),
        ),
    );

    return body;
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final VoidCallback? onPressed;

  _DialogButton({required this.text, this.textColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MyButton(
          text: text,
            textColor: textColor,
            backgroundColor: Colors.transparent,
            onPressed: onPressed
        )
    );
  }
}
