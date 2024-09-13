import 'package:deer_imitate/mvp/base_page_presenter.dart';
import 'package:deer_imitate/net/http_api.dart';
import 'package:deer_imitate/order/iview/order_search_iview.dart';
import 'package:deer_imitate/order/models/search_entity.dart';
import 'package:deer_imitate/utils/dio_utils.dart';
import 'package:deer_imitate/widgets/state_layout.dart';

class OrderSearchPresenter extends BasePagePresenter<OrderSearchIMvpView>{
  Future<dynamic> search(String text,int page,bool isShowDialog){
    final Map<String,String> params = <String,String>{};
    params['q'] = text;
    params['page'] = page.toString();
    params['l'] = 'Dart';
    return requestNetWork<SearchEntity>(Method.get, url: HttpApi.search,
    queryParameters: params,isShow: isShowDialog,
    onSuccess: (data){
      if(data != null && data.items != null){
        view.provider.hasMore = data.items!.length == 30;
        if(page == 1){
          view.provider.list.clear();
          if(data.items!.isEmpty){
            view.provider.setStateType(StateType.order);
          }else{
            view.provider.addAll(data.items!);
          }
        }else{
          view.provider.addAll(data.items!);
        }
      }else{
        view.provider.hasMore = false;
        view.provider.setStateType(StateType.network);
      }
    },
        onError: (_, __) {
          print("onerror presenter");
          /// 加载失败
          view.provider.hasMore = false;
          view.provider.setStateType(StateType.network);
        });
  }
}