import 'package:deer_imitate/goods/page/goods_list_page.dart';
import 'package:deer_imitate/goods/provider/goods_page_provider.dart';
import 'package:deer_imitate/goods/widgets/goods_add_menu.dart';
import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/res/resources.dart';
import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/toast_utils.dart';
import '../../widgets/popup_window.dart';
import '../widgets/goods_sort_menu.dart';

class GoodsPage extends StatefulWidget {
  const GoodsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GoodsPageState();
  }
}

class _GoodsPageState extends State<GoodsPage> with SingleTickerProviderStateMixin{
  GoodsPageProvider provider = GoodsPageProvider();
  final List<String> _sortList = [
    '全部商品',
    '个人护理',
    '饮料',
    '沐浴洗护',
    '厨房用具',
    '休闲食品',
    '生鲜水果',
    '酒水',
    '家庭清洁'
  ];
  final GlobalKey _addKey = GlobalKey();
  TabController? _tabController ;
  final PageController _pageController = PageController();
  final GlobalKey _bodyKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = ThemeUtils.getIconColor(context);
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: LoadAssetImage(
                'goods/search',
                key: const Key('search'),
                width: 24.0,
                height: 24.0,
                color: iconColor,
              ),
            ),
            IconButton(
                onPressed: () {
                  _showAddMenu();
                },
                key: _addKey,
                icon: LoadAssetImage(
                  'goods/add',
                  key: const Key('add'),
                  width: 24.0,
                  height: 24.0,
                  color: iconColor,
                )),
          ],
        ),
        body: Column(
          key:_bodyKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              key: _buttonKey,
                child: Selector<GoodsPageProvider, int>(
                builder: (_, sortIndex, __) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gaps.hGap16,
                      Text(
                        _sortList[sortIndex],
                        style: TextStyles.textBold24,
                      ),
                      Gaps.hGap8,
                      LoadAssetImage(
                        'goods/expand',
                        width: 16.0,
                        height: 16.0,
                        color: iconColor,
                      )
                    ],
                  );
              },
              selector: (_, provider) => provider.sortIndex,
            ),
            onTap:(){
              _showSortMenu();
            } ,
            ),
            Gaps.vGap24,
            Container(
              padding: EdgeInsets.only(left: 16.0),
              color: context.backgroundColor,
              child: TabBar(
                isScrollable: true,
                  controller: _tabController,
                  labelStyle: TextStyles.textBold18,
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colours.text,
                  labelColor: Theme.of(context).primaryColor,
                  indicatorPadding: EdgeInsets.only(right: 98-36),
                  indicatorWeight: 2.0,
                  tabs: [
                    _TabView('在售', 0),
                    _TabView('待售', 1),
                    _TabView('下架', 2),
                  ],
                onTap:(index){
                  if(!mounted)
                    return;
                  _pageController.jumpToPage(index);
                }
              ),
            ),
            Gaps.line,
            Expanded(
                child: PageView.builder(
                  itemCount: 3,
                    onPageChanged: _onPageChange,
                    controller: _pageController,
                    itemBuilder: (_,int index) => GoodsListPage(index: index)
                )
            )
          ],
        ),
      ),
    );
  }
  void _onPageChange(int index){
    _tabController?.animateTo(index);
    provider.setIndex(index);
  }

  void _showSortMenu(){
    final RenderBox button = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox body = _bodyKey.currentContext!.findRenderObject()! as RenderBox;
    showPopupWindow<void>(
      context: context,
      offset: const Offset(0.0, 12.0),
      anchor: button,
      child: GoodsSortMenu(
        data: _sortList,
        height: body.size.height - button.size.height,
        sortIndex: provider.sortIndex,
        onSelected: (index, name) {
          provider.setSortIndex(index);
          Toast.show('选择分类: $name');
        },
      ),
    );
  }

  void _showAddMenu(){
    final RenderBox button = _addKey.currentContext?.findRenderObject() as RenderBox;
    showPopupWindow<void>(
        context: context,
        anchor: button,
        offset: Offset(button.size.width - 8.0, -12.0),
        child: const GoodsAddMenu());
  }
}

class _TabView extends StatelessWidget{
  final String tabName;
  final int index;

  _TabView(this.tabName, this.index);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: SizedBox(
        width: 98.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tabName),
            Consumer<GoodsPageProvider>(
                builder: (_,provider,child){
                  return Visibility(
                    visible: provider.goodsCountList[index] > 0 && provider.index == index,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                        child: Text('(${provider.goodsCountList[index]}件)',
                        style: TextStyle(fontSize: Dimens.font_sp12),),
                      )
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
