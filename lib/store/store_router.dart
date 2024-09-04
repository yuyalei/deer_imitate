import 'package:deer_imitate/routers/i_router.dart';
import 'package:deer_imitate/store/page/store_audit_page.dart';
import 'package:deer_imitate/store/page/store_audit_result_page.dart';
import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';

class StoreRouter implements IRouterProvider{
  static String auditPage = '/store/audit';
  static String auditResultPage = '/store/auditResult';
  @override
  void initRouter(FluroRouter router) {
    router.define(auditPage, handler: Handler(handlerFunc: (_, __) => const StoreAuditPage()));
    router.define(auditResultPage, handler: Handler(handlerFunc: (_,__) => const StoreAuditResultPage()));
  }

}