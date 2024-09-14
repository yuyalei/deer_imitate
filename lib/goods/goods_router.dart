import 'package:common_utils/common_utils.dart';
import 'package:deer_imitate/goods/page/goods_edit_page.dart';
import 'package:deer_imitate/routers/i_router.dart';
import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';

class GoodsRouter implements IRouterProvider{
  static String goodsEditPage = '/goods/edit';
  @override
  void initRouter(FluroRouter router) {
    router.define(goodsEditPage, handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
      final bool isAdd = params['isAdd']?.first == 'true';
      final bool isScan = params['isScan']?.first == 'true';
      final String url = EncryptUtil.decodeBase64(params['url']?.first ?? '');
      final String heroTag = params['heroTag']?.first ?? 'heroTag';
      return GoodsEditPage(isAdd: isAdd, isScan: isScan, goodsImageUrl: url, hereTag: heroTag,);
    }));
  }
  
}