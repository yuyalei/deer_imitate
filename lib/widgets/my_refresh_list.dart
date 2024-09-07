
import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/widgets/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeerListView extends StatefulWidget{
  final RefreshCallback onRefresh;
  final LoadMoreCallback? loadMore;
  final int itemCount;
  final bool hasMore;
  final IndexedWidgetBuilder itemBuilder;
  final StateType stateType;
  /// 一页的数量，默认为10
  final int pageSize;
  /// padding属性使用时注意会破坏原有的SafeArea，需要自行计算bottom大小
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;


  DeerListView(
      this.onRefresh,
      this.loadMore,
      this.itemCount,
      this.hasMore,
      this.itemBuilder,
      this.stateType,
      this.pageSize,
      this.padding,
      this.itemExtent);

  @override
  State<StatefulWidget> createState() {
    return  _DeerListViewState();
  }

}

typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

class _DeerListViewState extends State<DeerListView>{
  /// 是否正在加载数据
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Widget child = RefreshIndicator(
        child: widget.itemCount==0? StateLayout(type: widget.stateType):
      ListView.builder(
        itemCount: widget.loadMore == null ? widget.itemCount:widget.itemCount+1,
          padding: widget.padding,
          itemExtent: widget.itemExtent,
          itemBuilder: (BuildContext context,int index){
            if(widget.loadMore == null){
              return widget.itemBuilder(context,index);
            }else{
              return index < widget.itemCount ? widget.itemBuilder(context,index):MoreWidget(widget.itemCount, widget.hasMore, widget.pageSize);
            }
          }
      ),
      onRefresh: widget.onRefresh,
    );

    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification note){
          if(note.metrics.pixels == note.metrics.maxScrollExtent && note.metrics.axis == Axis.vertical){
            _loadMore();
          }
          return true;
        },
          child: child),
    )
  }

  Future<void> _loadMore() async {
    if (widget.loadMore == null) {
      return;
    }
    if (_isLoading) {
      return;
    }
    if (!widget.hasMore) {
      return;
    }
    _isLoading = true;
    await widget.loadMore?.call();
    _isLoading = false;
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
        children: [
          if(hasMore) CupertinoActivityIndicator(),
          if(hasMore) Gaps.hGap5,
          Text(hasMore ? '正在加载中...' : (itemCount < pageSize ? '' : '没有了呦~'), style: style),
        ],
      ),
    )
  }
}