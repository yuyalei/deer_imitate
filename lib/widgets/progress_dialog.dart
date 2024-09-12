import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/gaps.dart';

class ProgressDialog extends Dialog {
  final String hintText;

  const ProgressDialog({super.key, this.hintText = ''});

  @override
  Widget build(BuildContext context) {
    final Widget progress = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
            data: ThemeData(
                cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
            )),
            child: const CupertinoActivityIndicator(radius: 14.0,)
        ),
        Gaps.vGap8,
        Text(hintText, style: const TextStyle(color: Colors.white),)
      ],
    );

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 88, width: 120,
          decoration: ShapeDecoration(
              color: Color(0xFF3A3A3A),
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          )),
          child: progress,
        ),
      ),
    );
  }
}
