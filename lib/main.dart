import 'package:deer_imitate/home/splash_page.dart';
import 'package:deer_imitate/res/constant.dart';
import 'package:deer_imitate/utils/dio_utils.dart';
import 'package:deer_imitate/utils/log_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import 'net/intercept.dart';

Future<void> main() async {
  if(Constant.inProduction){
    /// Release环境时不打印debugPrint内容
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Widget? home;
  final ThemeData? theme;
  MyApp({super.key,this.home, this.theme}){
    Log.init();
    initDio();
  }

  void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    /// 刷新Token
    interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    interceptors.add(AdapterInterceptor());
    configDio(
      baseUrl: 'https://api.github.com/',
      interceptors: interceptors,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _buildMaterialApp();
  }
}

Widget _buildMaterialApp(){
  return MaterialApp(
    title: "Flutter inmitate",
    debugShowCheckedModeBanner: false,
    showSemanticsDebugger: true,
    checkerboardOffscreenLayers: true, // 检查离屏渲染
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const SplashPage(),
  );
}