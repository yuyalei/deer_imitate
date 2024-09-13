
import 'package:deer_imitate/mvp/base_page.dart';
import 'package:deer_imitate/mvp/power_presenter.dart';
import 'package:deer_imitate/order/iview/order_search_iview.dart';
import 'package:deer_imitate/order/models/search_entity.dart';
import 'package:deer_imitate/order/presenter/order_search_presenter.dart';
import 'package:deer_imitate/order/provider/base_list_provider.dart';
import 'package:deer_imitate/order/widgets/my_search_bar.dart';
import 'package:deer_imitate/widgets/my_refresh_list.dart';
import 'package:deer_imitate/widgets/state_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSearchPage extends StatefulWidget{
  const OrderSearchPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _OrderSearchPageState();
  }

}

class _OrderSearchPageState extends State<OrderSearchPage> with BasePageMixin<OrderSearchPage,PowerPresenter<dynamic>> implements OrderSearchIMvpView{
  late String _keyword;
  int _page = 1;
  late OrderSearchPresenter _orderSearchPresenter;

  @override
  void initState() {
    provider.stateType = StateType.empty;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BaseListProvider<SearchItems>>(
        create: (_) => provider,
      child: Scaffold(
        appBar: MySearchBar(
          hintText: '请输入手机号或姓名查询',
          onPressed: (text){
            if(text.isEmpty){
              showToast('搜索关键字不能为空！');
              return;
            }
            _keyword = text;
            provider.setStateType(StateType.loading);
            _page = 1;
            _orderSearchPresenter.search(_keyword, _page, true);
          },
        ),
        body: Consumer<BaseListProvider<SearchItems>>(
            builder: (_,provider,__){
              return DeerListView(
                  itemCount:  provider.list.length,
                  stateType: provider.stateType,
                  onRefresh: _onRefresh,
                  loadMore: _loadMore,
                  itemExtent: 50.0,
                  hasMore: provider.hasMore,
                  itemBuilder: (_,index){
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(provider.list[index].name??''),
                    );
                  }, );
            }
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _page = 1;
    await _orderSearchPresenter.search(_keyword, _page, false);
  }

  Future<void> _loadMore() async {
    _page++;
    await _orderSearchPresenter.search(_keyword, _page, false);
  }
  @override
  PowerPresenter createPresenter() {
    final PowerPresenter<dynamic> powerPresenter = PowerPresenter<dynamic>(this);
    _orderSearchPresenter = OrderSearchPresenter();
    powerPresenter.requestPresenter([_orderSearchPresenter]);
    return powerPresenter;
  }

  // @override
  // BaseListProvider<SearchItems> get provider => BaseListProvider<SearchItems>();

  @override
  BaseListProvider<SearchItems> provider = BaseListProvider<SearchItems>();

}