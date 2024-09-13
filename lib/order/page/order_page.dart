import 'package:deer_imitate/home/page/home_page.dart';
import 'package:deer_imitate/order/order_router.dart';
import 'package:deer_imitate/order/page/order_list_page.dart';
import 'package:deer_imitate/order/provider/order_page_provider.dart';
import 'package:deer_imitate/res/resources.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:deer_imitate/widgets/my_flexible_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/image_utils.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OrderPageState();
  }
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  OrderPageProvider provider = OrderPageProvider();

  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preCacheImage();
    });
  }

  void _preCacheImage() {
    precacheImage(ImageUtils.getAssetImage('order/xdd_n'), context);
    precacheImage(ImageUtils.getAssetImage('order/dps_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/dwc_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/ywc_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/yqx_s'), context);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderPageProvider>(
        create: (_) => provider,
        child: Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: SizedBox(
                  height: 105,
                  width: double.infinity,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                    Colours.gradient_blue,
                    Color(0xFF4647FA)
                  ]))),
                ),
              ),
              NestedScrollView(
                  physics: ClampingScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) =>
                      _sliverBuilder(context),
                  body: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        if (notification.depth == 0 &&
                            notification is ScrollEndNotification) {
                          final PageMetrics metrics =
                              notification.metrics as PageMetrics;
                          final int currentPage = (metrics.page ?? 0).round();
                          if (currentPage != _lastReportedPage) {
                            _lastReportedPage = currentPage;
                            _onPageChange(currentPage);
                          }

                          // 1. 判断监听的类型
                          if (notification is ScrollStartNotification) {
                            print('开始滚动...');
                          } else if (notification is ScrollUpdateNotification) {
                            // 当前滚动的位置和长度
                            final currentPixel = notification.metrics.pixels;
                            final totalPixel =
                                notification.metrics.maxScrollExtent;
                            double progress = currentPixel / totalPixel;

                            print(
                                '正在滚动: currentPixel=$currentPixel totalPixel=$totalPixel');
                          } else if (notification is ScrollEndNotification) {
                            print('结束滚动...');
                          }
                        }
                        return false;
                      },
                      child: PageView.builder(
                        itemCount: 5,
                        controller: _pageController,
                        itemBuilder: (_, index) => OrderListPage(index: index),
                      )))
            ],
          ),
        ));
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          systemOverlayStyle: ThemeUtils.dark,
          actions: [
            IconButton(
              onPressed: () {NavigatorUtils.push(context, OrderRouter.orderSearchPage);},
              icon: LoadAssetImage(
                'order/icon_search',
                width: 22.0,
                height: 22.0,
                color: ThemeUtils.getIconColor(context),
              ),
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 100.0,
          // 不随着滑动隐藏标题
          pinned: true,
          // 固定在顶部
          flexibleSpace: MyFlexibleSpaceBar(
            background: LoadAssetImage(
              'order/order_bg',
              width: MediaQuery.of(context).size.width,
              height: 113.0,
              fit: BoxFit.fill,
            ),
            centerTitle: true,
            titlePadding:
                const EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0),
            collapseMode: CollapseMode.pin,
            title: Text(
              '订单',
              style: TextStyle(color: ThemeUtils.getIconColor(context)),
            ),
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colours.dark_bg_gray,
                image: DecorationImage(
                    image: ImageUtils.getAssetImage('order/order_bg1'),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red,
                            offset: const Offset(0.0, 2.0),
                            blurRadius: 8.0)
                      ]),
                  child: Container(
                    height: 80.0,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TabBar(
                      labelPadding: EdgeInsets.zero,
                      controller: _tabController,
                      labelColor: Colours.text,
                      unselectedLabelColor: Colours.dark_text_gray,
                      labelStyle: TextStyles.textBold14,
                      unselectedLabelStyle:
                          TextStyle(fontSize: Dimens.font_sp14),
                      indicatorColor: Colors.transparent,
                      tabs: [
                        _TabView(0, '新订单'),
                        _TabView(1, '待配送'),
                        _TabView(2, '待完成'),
                        _TabView(3, '已完成'),
                        _TabView(4, '已取消'),
                      ],
                      onTap: (index) {
                        if (!mounted) {
                          return;
                        }
                        _pageController.jumpToPage(index);
                      },
                    ),
                  ),
                ),
              ),
            ),
            80),
      )
    ];
  }

  final PageController _pageController = PageController();

  Future<void> _onPageChange(int index) async {
    provider.setIndex(index);
    _tabController?.animateTo(index, duration: Duration(milliseconds: 500));
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;

  SliverAppBarDelegate(this.widget, this.height);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

List<List<String>> img = [
  ['order/xdd_s', 'order/xdd_n'],
  ['order/dps_s', 'order/dps_n'],
  ['order/dwc_s', 'order/dwc_n'],
  ['order/ywc_s', 'order/ywc_n'],
  ['order/yqx_s', 'order/yqx_n']
];

class _TabView extends StatelessWidget {
  final int index;
  final String text;

  _TabView(this.index, this.text);

  @override
  Widget build(BuildContext context) {
    final List<List<String>> imgList = img;
    var i = context.select<OrderPageProvider, int>((value) {
      return value.index;
    });
    return Stack(
      children: [
        Container(
          width: 46.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              //LoadAssetImage(context.select<OrderPageProvider,int>((value) => value.index) == index ?
              LoadAssetImage(
                i == index ? imgList[index][0] : imgList[index][1],
                width: 24,
                height: 24,
              ),
              Gaps.hGap4,
              Text(text)
            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: index < 3
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.5, vertical: 2.0),
                    child: Text(
                      '10',
                      style: TextStyle(
                          color: Colors.white, fontSize: Dimens.font_sp12),
                    ),
                  ),
                )
              : Gaps.empty,
        )
      ],
    );
  }
}
