
import 'package:deer_imitate/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleTapBackExitApp extends StatefulWidget{
  final Widget child;
  final Duration duration;


  DoubleTapBackExitApp({super.key,required this.child, this.duration = const Duration(milliseconds: 2500)});

  @override
  State<StatefulWidget> createState() {
    return _DoubleTapBackExitAppState();
  }

}
class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp>{
  DateTime? _lastTime;
  bool canPopNow = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: widget.child,
      canPop: canPopNow,
      onPopInvokedWithResult: (didPop,dynamic) async {
        final now = DateTime.now();
        if (_lastTime == null || now.difference(_lastTime!) >  widget.duration) {
          _lastTime = now;
          Toast.show('再次点击退出应用');
          setState(() {
            canPopNow = false;
          });
          return;
        } else {
          setState(() {
            canPopNow = true;
          });
          Toast.cancelToast();
          await SystemNavigator.pop();
        }
      },
    );
  }

  Future _isExit(bool pop) async {
    if(_lastTime == null || DateTime.now().difference(_lastTime!) > widget.duration){
      _lastTime = DateTime.now();
      Toast.show('再次点击退出应用');
      return Future.value(false);
    }
    Toast.cancelToast();
    await SystemNavigator.pop();
    return Future.value(true);
  }
}
