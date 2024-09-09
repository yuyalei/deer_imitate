import 'package:common_utils/common_utils.dart';
import 'package:deer_imitate/goods/models/goods_item_entity.dart';
import 'package:deer_imitate/goods/provider/goods_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/constant.dart';
import '../../routers/fluro_navigator.dart';
import '../../utils/toast_utils.dart';
import '../../widgets/my_refresh_list.dart';
import '../../widgets/state_layout.dart';
import '../widgets/goods_delete_bottom_sheet.dart';
import 'goods_item.dart';

class GoodsListPage extends StatefulWidget {
  final int index;

  GoodsListPage({super.key, required this.index});

  @override
  State<StatefulWidget> createState() {
    return _GoodsListPageState();
  }

}

class _GoodsListPageState extends State<GoodsListPage>
    with SingleTickerProviderStateMixin {
  int _selectIndex = -1;
  late Animation<double> _animation;
  late AnimationController _controller;
  List<GoodsItemEntity> _list = [];
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
    final curedAnimation = CurvedAnimation(
        parent: _controller, curve: Curves.easeOutSine);
    _animation = Tween(begin: 0.0, end: 1.1).animate(curedAnimation)
      ..addStatusListener((status) {
        _animationStatus = status;
      });

    _maxPage = widget.index == 0 ? 1 : (widget.index == 1 ? 2 : 3);
    _onRefresh();
    super.initState();
  }

  int _page = 1;
  late int _maxPage;
  StateType _stateType = StateType.loading;

  @override
  Widget build(BuildContext context) {
    return DeerListView(
        itemCount: _list.length,
        stateType: _stateType,
        onRefresh: _onRefresh,
        loadMore: _loadMore,
        hasMore: _page < _maxPage,
        itemBuilder: (_, index) {
          final String heroTag = 'goodsImg${widget.index}-$index';
          return GoodsItem(
            index: index,
            heroTag: heroTag,
            selectIndex: _selectIndex,
            item: _list[index],
            animation: _animation,
            onTapMenu: () {
              /// 点击其他item时，重置状态
              if (_selectIndex != index) {
                _animationStatus = AnimationStatus.dismissed;
              }
              /// 避免动画中重复执行
              if (_animationStatus == AnimationStatus.dismissed) {
                // 开始执行动画
                _controller.forward(from: 0.0);
              }
              setState(() {
                _selectIndex = index;
              });
            },
            onTapMenuClose: () {
              if (_animationStatus == AnimationStatus.completed) {
                _controller.reverse(from: 1.1);
              }
              _selectIndex = -1;
            },
            onTapEdit: () {
              setState(() {
                _selectIndex = -1;
              });
              final String url = EncryptUtil.encodeBase64(_list[index].icon);
              //NavigatorUtils.push(context, '${GoodsRouter.goodsEditPage}?isAdd=false&url=$url&heroTag=$heroTag');
            },
            onTapOperation: () {
              Toast.show('下架');
            },
            onTapDelete: () {
              _controller.reverse(from: 1.1);
              _selectIndex = -1;
              _showDeleteBottomSheet(index);
            },
          );
        }
    );
  }

  final List<String> _imgList = [
    'https://hbimg.b0.upaiyun.com/29cdf569b916ec8b952804a93b0a77e8c9baf61a58e0b-A0orbz_fw658',
    if (Constant.isDriverTest)
      'https://hbimg.huabanimg.com/a3947661524be662da9f40d95dddc73c66196816633e1-9bUI91_fw658'
    else
      'https://xxx', // 可以使用一张无效链接，触发缺省、异常显示图片
    'https://hbimg.huabanimg.com/528c11bba65e2b8c0b6ae56f05e66b68f78f545f4ff26-tkM2Lx_fw658',
    'https://img2.baidu.com/it/u=272387872,295674292&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',
    'https://img0.baidu.com/it/u=2202484983,917817934&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',
    'https://img0.baidu.com/it/u=2329453320,961102964&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
  ];

  Future<dynamic> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _page = 1;
        _list = List.generate(widget.index == 0 ? 3 : 10, (i) =>
            GoodsItemEntity(icon: _imgList[i % 6],
                title: '八月十五中秋月饼礼盒',
                type: i % 3));
      });
      _setGoodsCount(_list.length);
    });
  }

  void _setGoodsCount(int count){
    Provider.of<GoodsPageProvider>(context,listen: false).setGoodsCount(count);
  }

  Future<dynamic> _loadMore()async{
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _list.addAll(List.generate(10, (i) =>
            GoodsItemEntity(icon: _imgList[i % 6], title: '八月十五中秋月饼礼盒', type: i % 3)));
        _page ++;
      });
      _setGoodsCount(_list.length);
    });
  }

  void _showDeleteBottomSheet(int index){
    showModalBottomSheet(context: context,
        builder: (BuildContext context){
          return GoodsDeleteBottomSheet(
            onTapDelete: () {
              setState(() {
                _list.removeAt(index);
                if (_list.isEmpty) {
                  _stateType = StateType.goods;
                }
              });
              _setGoodsCount(_list.length);
            },
          );
        });
  }
}