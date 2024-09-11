import 'package:deer_imitate/order/page/order_info_page.dart';
import 'package:deer_imitate/order/page/order_page.dart';
import 'package:deer_imitate/order/page/order_track_page.dart';
import 'package:deer_imitate/routers/i_router.dart';
import 'package:fluro/fluro.dart';

class OrderRouter implements IRouterProvider{
  static String orderPage = '/order';
  static String orderInfoPage = '/order/info';
  static String orderTrackPage = '/order/track';

  @override
  void initRouter(FluroRouter router) {
    router.define(orderPage,handler: Handler(handlerFunc: (_,__) => const OrderPage()));
    router.define(orderInfoPage, handler: Handler(handlerFunc: (_,__) => const OrderInfoPage()));
    router.define(orderTrackPage, handler: Handler(handlerFunc: (_,__) => const OrderTrackPage()));
  }
}