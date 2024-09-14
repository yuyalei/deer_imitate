import 'package:deer_imitate/login/login_router.dart';
import 'package:deer_imitate/order/order_router.dart';
import 'package:deer_imitate/store/store_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../goods/goods_router.dart';
import '../home/page/home_page.dart';
import 'i_router.dart';
import 'not_found_page.dart';

class Routes{
  static String home = '/home';

  static final List<IRouterProvider> _listRouter = [];
  static final FluroRouter router = FluroRouter();
  static void initRoutes(){
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context,Map<String,List<String>>params){
          debugPrint('未找到目标页');
          return const NotFoundPage();
        }
    );
    router.define(home, handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const Home()));


    _listRouter.clear();
    _listRouter.add(LoginRouter());
    _listRouter.add(StoreRouter());
    _listRouter.add(OrderRouter());
    _listRouter.add(GoodsRouter());

    void initRouter(IRouterProvider routerProvider){
      routerProvider.initRouter(router);
    }

    _listRouter.forEach(initRouter);
  }
}