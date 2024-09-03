import 'dart:async';

import 'package:deer_imitate/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../res/gaps.dart';
import '../../widgets/my_button.dart';

class MyTextField extends StatefulWidget{

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode? focusNode;
  final bool isInputPwd;
  final Future<bool> Function()? getVCode;
  /// 用于集成测试寻找widget
  final String? keyName;


  MyTextField({
    super.key,
      required this.controller,
      this.maxLength = 16,
      this.autoFocus = false,
      this.keyboardType = TextInputType.text,
      this.hintText = '',
      this.focusNode,
      this.isInputPwd = false,
      this.getVCode,
      this.keyName});

  @override
  State<StatefulWidget> createState() => _MyTextFieldState();

}

class _MyTextFieldState extends State<MyTextField>{
  bool _isShowPwd = false;
  bool _isShowDelete = false;
  bool _clickable = true;
  /// 倒计时秒数
  final int _second = 30;
  /// 当前秒数
  late int _currentSecond;
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    _isShowDelete = widget.controller.text.isNotEmpty;
    widget.controller.addListener(isEmpty);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDark = themeData.brightness == Brightness.dark;

    Widget textField = TextField(
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: widget.isInputPwd && !_isShowPwd,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      textInputAction: TextInputAction.done,
      keyboardType: widget.keyboardType,
      // 数字、手机号限制格式为0到9， 密码限制不包含汉字
      inputFormatters: (widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone) ?
      [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] : [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        hintText: widget.hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:themeData.primaryColor,
            width: 0.8,
          )
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.8,
          )
        )
      ),
    );

    Widget? clearButton;
    if(_isShowDelete){
      clearButton = Semantics(
        label: '清空',
        hint: '清空输入框',
        child: GestureDetector(
          child: LoadAssetImage(
            'login/qyg_shop_icon_delete',
            width: 18.0,
            height: 40.0,
          ),
          onTap: () => widget.controller.text = '',
        ),
      );
    }

    late Widget pwdVisible;
    if (widget.isInputPwd) {
      pwdVisible = Semantics(
        label: '密码可见开关',
        hint: '密码是否可见',
        child: GestureDetector(
          child: LoadAssetImage(
            _isShowPwd ? 'login/qyg_shop_icon_display' : 'login/qyg_shop_icon_hide',
            key: Key('${widget.keyName}_showPwd'),
            width: 18.0,
            height: 40.0,
          ),
          onTap: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
        ),
      );
    }

    late Widget getVCodeButton;
    if (widget.getVCode != null) {
      getVCodeButton = MyButton(
        key: const Key('getVerificationCode'),
        onPressed: _clickable ? _getVCode : null,
        fontSize: Dimens.font_sp12,
        text: _clickable ? "获取验证码" : '（$_currentSecond s）',
        textColor: themeData.primaryColor,
        disabledTextColor: isDark ? Colours.dark_text : Colors.white,
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: isDark ? Colours.dark_text_gray : Colours.text_gray_c,
        radius: 1.0,
        minHeight: 26.0,
        minWidth: 76.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        side: BorderSide(
          color: _clickable ? themeData.primaryColor : Colors.transparent,
          width: 0.8,
        ),
      );
    }

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        textField,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// _isShowDelete参数动态变化，为了不破坏树结构使用Visibility，false时放一个空Widget。
            /// 对于其他参数，为初始配置参数，基本可以确定树结构，就不做空Widget处理。
            Visibility(
              visible: _isShowDelete,
              child: clearButton ?? Gaps.empty,
            ),
            if (widget.isInputPwd) Gaps.hGap15,
            if (widget.isInputPwd) pwdVisible,
            if (widget.getVCode != null) Gaps.hGap15,
            if (widget.getVCode != null) getVCodeButton,
          ],
        )
      ],
    );
  }

  void isEmpty(){
    final bool isNotEmpty =widget.controller.text.isNotEmpty;
    if(isNotEmpty != _isShowDelete){
      setState(() {
        _isShowDelete = isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    widget.controller.removeListener(isEmpty);
    super.dispose();
  }

  Future<dynamic> _getVCode() async {
    final bool isSuccess = await widget.getVCode!();
    if(isSuccess){
      setState(() {
        _currentSecond = _second;
        _clickable = false;
      });_subscription = Stream.periodic(const Duration(seconds: 1),(int i)=>i).take(_second).listen((int i){
        setState(() {
          _currentSecond = _second -i - 1;
          _clickable = _currentSecond < 1;
        });
      });
    }
  }

}