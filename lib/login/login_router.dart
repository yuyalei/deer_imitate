import 'package:deer_imitate/login/page/login_page.dart';
import 'package:deer_imitate/routers/i_router.dart';
import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';

class LoginRouter implements IRouterProvider{
  static String loginPage = '/login';
  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => LoginPage()));
  }

}