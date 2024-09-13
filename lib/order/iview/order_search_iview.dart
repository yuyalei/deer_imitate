import 'package:deer_imitate/mvp/mvps.dart';
import 'package:deer_imitate/order/models/search_entity.dart';
import 'package:deer_imitate/order/provider/base_list_provider.dart';

abstract class OrderSearchIMvpView implements IMvpView{
  BaseListProvider<SearchItems> get provider;
}