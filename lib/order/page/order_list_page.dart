import 'package:deer_imitate/order/provider/order_page_provider.dart';
import 'package:deer_imitate/widgets/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/gaps.dart';
import '../widgets/order_item.dart';
import '../widgets/order_tag_item.dart';

class OrderListPage extends StatefulWidget {

  const OrderListPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final StateType _stateType = StateType.loading;
  final ScrollController _controller = ScrollController();
  final int _maxPage = 3;
  int _page = 1;
  int _index = 0;
  List<String> _list = <String>[];

  /// 是否正在加载数据
  bool _isLoading = false;

  @override
  void initState() {
    _index = widget.index;
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (ScrollNotification note) {
          if (note.metrics.pixels == note.metrics.maxScrollExtent) {
            _loadMore();
          }
          return true;
        },
        child: RefreshIndicator(
            onRefresh: _onRefresh,
          child: Consumer<OrderPageProvider>(
              builder: (_,provider,child){
                return CustomScrollView(
                  controller: _index != provider.index ? _controller:null,
                  slivers: [
                    SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                    child!
                  ],
                );
              },
            child: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: _list.isEmpty ? SliverFillRemaining(child: StateLayout(type: _stateType,),):
              SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                    return index < _list.length ?
                    (index % 5 == 0 ?
                    const OrderTagItem(date: '2021年2月5日', orderTotal: 4) :
                    OrderItem(key: Key('order_item_$index'), index: index, tabIndex: _index,)):
                    MoreWidget(_list.length, _hasMore(), 10);
                  },childCount: _list.length+1),

              ),
            ),
          ),
        ),
    );
  }

  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _page = 1;
        _list = List.generate(10, (i) => 'newItem: $i');
      });
    });
  }

  bool _hasMore() {
    return _page < _maxPage;
  }

  Future<void> _loadMore() async {
    if (_isLoading) {
      return;
    }
    if (!_hasMore())
      return;
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _list.addAll(List.generate(10, (i) => 'newItem $i'));
        _page++;
        _isLoading = false;
      });
    });
  }
}

class MoreWidget extends StatelessWidget{
  const MoreWidget(this.itemCount, this.hasMore, this.pageSize, {super.key});

  final int itemCount;
  final bool hasMore;
  final int pageSize;
  @override
  Widget build(BuildContext context) {
    final TextStyle style = const TextStyle(color: Color(0x8A000000));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (hasMore) const CupertinoActivityIndicator(),
          if (hasMore) Gaps.hGap5,
          /// 只有一页的时候，就不显示FooterView了
          Text(hasMore ? '正在加载中...' : (itemCount < pageSize ? '' : '没有了呦~'), style: style),
        ],
      ),
    );
  }
}