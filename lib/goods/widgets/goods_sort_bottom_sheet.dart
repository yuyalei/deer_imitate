import 'package:deer_imitate/goods/page/goods_edit_page.dart';
import 'package:deer_imitate/goods/provider/goods_sort_provider.dart';
import 'package:deer_imitate/res/dimens.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../widgets/load_image.dart';

class GoodsSortBottomSheet extends StatefulWidget {
  final void Function(String, String) onSelected;
  final GoodsSortProvider provider;

  const GoodsSortBottomSheet(
      {required this.onSelected, required this.provider});

  @override
  State<StatefulWidget> createState() {
    return GoodsSortBottomSheetState();
  }
}

class GoodsSortBottomSheetState extends State<GoodsSortBottomSheet>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.initData();
      _tabController?.animateTo(widget.provider.index, duration: Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 11.0 / 16.0,
          child: ChangeNotifierProvider<GoodsSortProvider>.value(
            value: widget.provider,
            child: Consumer<GoodsSortProvider>(
              builder: (_, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child!,
                    Gaps.line,
                    ColoredBox(
                        color: context.dialogBackgroundColor,
                      child: TabBar(
                        controller: _tabController,
                          isScrollable: true,
                        onTap: (index){
                          if(provider.myTabs[index].text!.isEmpty){
                            _tabController?.animateTo(provider.index);
                            return;
                          }
                          provider.setList(index);
                          provider.setIndex(index);
                          _controller.animateTo(
                              provider.positions[provider.index] * 48.0,
                              duration: const Duration(milliseconds: 10), curve: Curves.ease
                          );
                        },
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelColor: context.isDark ? Colours.text_gray : Colours.text,
                        labelColor: Theme.of(context).primaryColor,
                          tabs: provider.myTabs,
                      ),
                    ),
                    Gaps.line,
                    Expanded(
                        child: ListView.builder(
                            controller: _controller,
                          itemExtent: 48,
                          itemBuilder: (_,index){
                              return _buildItem(provider, index);
                          },
                          itemCount: provider.mList.length,
                        )
                    )
                  ],
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: const Text(
                      '商品分类',
                      style: TextStyles.textBold16,
                    ),
                  ),
                  Positioned(
                      right: 16.0,
                      top: 16.0,
                      bottom: 16.0,
                      child: InkWell(
                        onTap: ()=> NavigatorUtils.goBack(context),
                        child: const SizedBox(
                          height: 16.0,
                          width: 16.0,
                          child: LoadAssetImage('goods/icon_dialog_close'),
                        ),
                      )
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem(GoodsSortProvider provider, int index) {
    final bool flag =
        provider.mList[index].name == provider.myTabs[provider.index].text;
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(provider.mList[index].name,
                style: flag
                    ? TextStyle(
                        fontSize: Dimens.font_sp14,
                        color: Theme.of(context).primaryColor)
                    : null),
            Gaps.hGap8,
            Visibility(
                visible: flag,
                child:
                    const LoadAssetImage('goods/xz', height: 16.0, width: 16.0))
          ],
        ),
      ),
      onTap: (){
        provider.myTabs[provider.index] = Tab(text: provider.mList[index].name);
        provider.positions[provider.index] = index;
        provider.indexIncrement();
        provider.setListAndChangeTab();
        if(provider.index > 2){
          provider.setIndex(2);
          widget.onSelected(provider.mList[index].id,provider.mList[index].name);
          NavigatorUtils.goBack(context);
        }
        _controller.animateTo(0.0, duration: const Duration(milliseconds: 100), curve: Curves.ease);
        _tabController?.animateTo(provider.index);
      },
    );
  }
}
