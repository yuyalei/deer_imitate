
import 'package:deer_imitate/home/provider/home_provider.dart';
import 'package:deer_imitate/home/splash_page.dart';
import 'package:deer_imitate/order/page/order_page.dart';
import 'package:deer_imitate/widgets/double_tap_back_exit_app.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../goods/page/goods_page.dart';
import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../shop/page/shope_page.dart';
import '../../statistics/page/statistics_page.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with RestorationMixin{
  static const double _imageSize = 25.0;
  late List<Widget> _pageList;
  final List<String> _appBarTitles = ['订单', '商品', '统计', '店铺'];
  final PageController _pageController = PageController();

  HomeProvider provider = HomeProvider(0);
  List<BottomNavigationBarItem>? _list;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void initData(){
    _pageList = [
      const OrderPage(),
      const GoodsPage(),
      const StatisticsPage(),
      const ShopPage(),
    ];
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem(){
    if(_list == null){
      const tabImages =[
        [
          LoadAssetImage('home/icon_order', width: _imageSize, color: Colours.unselected_item_color,),
          LoadAssetImage('home/icon_order', width: _imageSize, color: Colours.app_main,),
        ],
        [
          LoadAssetImage('home/icon_commodity', width: _imageSize, color: Colours.unselected_item_color,),
          LoadAssetImage('home/icon_commodity', width: _imageSize, color: Colours.app_main,),
        ],
        [
          LoadAssetImage('home/icon_statistics', width: _imageSize, color: Colours.unselected_item_color,),
          LoadAssetImage('home/icon_statistics', width: _imageSize, color: Colours.app_main,),
        ],
        [
          LoadAssetImage('home/icon_shop', width: _imageSize, color: Colours.unselected_item_color,),
          LoadAssetImage('home/icon_shop', width: _imageSize, color: Colours.app_main,),
        ]
      ];
      _list = List.generate(tabImages.length, (i){
        return BottomNavigationBarItem(
            icon: tabImages[i][0],
          activeIcon: tabImages[i][1],
          label: _appBarTitles[i],
          tooltip: _appBarTitles[i],
        );
      });
    }
    return _list!;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (BuildContext context) => provider,
      child: DoubleTapBackExitApp(
          child: Scaffold(
            bottomNavigationBar: Consumer<HomeProvider>(
                builder: (_,provider,__){
                  return BottomNavigationBar(
                    backgroundColor: const Color(0xffF7F9FB),
                    items: _buildBottomNavigationBarItem(),
                    type: BottomNavigationBarType.fixed,
                    currentIndex: provider.value,
                    elevation: 5.0,
                    iconSize: 21.0,
                    selectedFontSize: Dimens.font_sp10,
                    unselectedFontSize: Dimens.font_sp10,
                    selectedItemColor: Theme.of(context).primaryColor,
                    unselectedItemColor:  Colours.unselected_item_color,
                    onTap: (index) => _pageController.jumpToPage(index),
                  );
                }
            ),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int index) => provider.value = index,
              children: _pageList,
            ),
          )
      ),

    );
  }

  @override
  String? get restorationId => 'home';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(provider, 'BottomNavigationBarCurrentIndex');
  }
}