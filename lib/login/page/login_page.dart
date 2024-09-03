import 'package:deer_imitate/login/widgets/my_test_field.dart';
import 'package:deer_imitate/res/constant.dart';
import 'package:deer_imitate/res/resources.dart';
import 'package:deer_imitate/utils/ChangeNotifierMixin.dart';
import 'package:deer_imitate/widgets/my_app_bar.dart';
import 'package:deer_imitate/widgets/my_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import '../../widgets/my_button.dart';

class LoginPage extends StatefulWidget{
  LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage> with ChangeNotifierMixin<LoginPage>{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isBack: false,
        actionName: "验证码登录",
        onPressed: (){
          _showSnackBar(context, "验证码登录");
        },
      ),
      body: MyScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody,
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
    Text("密码登录",style: TextStyles.textBold26,),
    Gaps.vGap16,
    MyTextField(
      focusNode: _nodeText1,
      controller: _nameController,
      maxLength: 11,
      keyboardType: TextInputType.phone,
      hintText: "输入账号",
    ),
    Gaps.vGap8,
    MyTextField(
      key: const Key('password'),
      keyName: 'password',
      focusNode: _nodeText2,
      isInputPwd: true,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      hintText: "请输入密码",
    ),
    Gaps.vGap24,
    MyButton(
      key: const Key('login'),
      onPressed: _clickable ? _login : null,
      text: "登录",
    ),
    Container(
      height: 40.0,
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: Text("忘记密码",
        style: Theme.of(context).textTheme.titleSmall),
        onTap: (){

        },
      ),
    ),
    Gaps.vGap16,
    Container(
      alignment: Alignment.center,
        child: GestureDetector(
          child: Text(
            "注册",
            key: const Key('noAccountRegister'),
            style: TextStyle(
                color: Theme.of(context).primaryColor
            ),
          ),
          onTap: () => {},
        )
    )
  ];

  @override
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return<ChangeNotifier,List<VoidCallback>?>{
      _nameController:callbacks,
      _passwordController:callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = SpUtil.getString(Constant.phone)?? '';
  }

  void _verify(){
    final String name = _nameController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    if(clickable !=_clickable){
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login(){
    _showSnackBar(context, "登陆成功");
    SpUtil.putString(Constant.phone, _nameController.text);
  }

  void _showSnackBar(BuildContext context,String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // 这里处理撤销操作
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}