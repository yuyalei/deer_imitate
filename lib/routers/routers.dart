import 'package:deer_imitate/login/login_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'i_router.dart';
import 'not_found_page.dart';

class Routes{
  static final List<IRouterProvider> _listRouter = [];
  static final FluroRouter router = FluroRouter();
  static void initRoutes(){
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context,Map<String,List<String>>params){
          debugPrint('未找到目标页');
          return const NotFoundPage();
        }
    );

    _listRouter.clear();
    _listRouter.add(LoginRouter());

    void initRouter(IRouterProvider routerProvider){
      routerProvider.initRouter(router);
    }

    _listRouter.forEach(initRouter);
  }
}