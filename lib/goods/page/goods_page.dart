import 'package:deer_imitate/goods/provider/goods_page_provider.dart';
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

class _GoodsPageState extends State<GoodsPage> {
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
  final GlobalKey _bodyKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();
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
                onPressed: () {},
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
          ],
        ),
      ),
    );
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
}
