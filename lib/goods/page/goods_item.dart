import 'package:common_utils/common_utils.dart';
import 'package:deer_imitate/goods/widgets/menu_reveal.dart';
import 'package:deer_imitate/res/dimens.dart';
import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/utils/device_utils.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:deer_imitate/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../utils/other_utils.dart';
import '../models/goods_item_entity.dart';

class GoodsItem extends StatelessWidget {
  final GoodsItemEntity item;
  final int index;
  final int selectIndex;
  final VoidCallback onTapMenu;
  final VoidCallback onTapEdit;
  final VoidCallback onTapOperation;
  final VoidCallback onTapDelete;
  final VoidCallback onTapMenuClose;
  final Animation<double> animation;
  final String heroTag;

  GoodsItem(
      {required this.item,
      required this.index,
      required this.selectIndex,
      required this.onTapMenu,
      required this.onTapEdit,
      required this.onTapOperation,
      required this.onTapDelete,
      required this.onTapMenuClose,
      required this.animation,
      required this.heroTag});

  Widget _buildGoodsMenu(BuildContext context){
    return Positioned.fill(
        child: AnimatedBuilder(
            animation: animation,
            child: _buildGoodsMenuContent(context),
          builder: (_,Widget? child){
            return MenuReveal(
                revealPercent: animation.value,
                child: child!
            );
          },
        )
    );
  }
  Widget _buildGoodsMenuContent(BuildContext context) {
    final Color buttonColor = Colors.white;
    return InkWell(
      onTap: onTapMenuClose,
      child: ColoredBox(
        color: const Color(0x4D000000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Gaps.hGap15,
            MyButton(
              fontSize: Dimens.font_sp16,
              radius: 24.0,
              minWidth: 56.0,
              minHeight: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              textColor: Colors.white,
              backgroundColor: Colours.app_main,
              onPressed: onTapEdit,
            ),
            MyButton(
              key: Key('goods_operation_item_$index'),
              text: '下架',
              fontSize: Dimens.font_sp16,
              radius: 24.0,
              minWidth: 56.0,
              minHeight: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              textColor: Colours.text,
              backgroundColor: buttonColor,
              onPressed: onTapOperation,
            ),
            MyButton(
              key: Key('goods_delete_item_$index'),
              text: '删除',
              fontSize: Dimens.font_sp16,
              radius: 24.0,
              minWidth: 56.0,
              minHeight: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              textColor: Colours.text,
              backgroundColor: buttonColor,
              onPressed: onTapDelete,
            ),
            Gaps.hGap15,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Row child = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
            tag: heroTag, 
            child: LoadAssetImage(item.icon, width: 72.0, height: 72.0)
        ),
        Gaps.hGap8,
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.type % 3 !=0 ? '八月十五中秋月饼礼盒' : '八月十五中秋月饼礼盒八月十五中秋月饼礼盒',
                maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.vGap4,
                Row(
                  children: [
                    Visibility(
                      visible: item.type % 3 == 0,
                      child: _GoodsItemTag(
                        text: '立减',
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    Opacity(
                      // 修改透明度实现隐藏，类似于invisible
                      opacity: item.type % 2 != 0 ? 0.0 : 1.0,
                      child: _GoodsItemTag(
                        text: '金币抵扣',
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                Gaps.vGap16,
                Text(Utils.formatPrice('20.00', format: MoneyFormat.NORMAL))
              ],
            )
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onTapMenu,
              child: Container(
                width: 44.0,
                height: 44.0,
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 28.0, bottom: 28.0),
                child: const LoadAssetImage('goods/ellipsis'),
              ),
            ),
            Padding( padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '特产美味',
                style: Theme.of(context).textTheme.titleSmall,
              ),)
          ],
        )
      ],
    );

    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: Divider.createBorderSide(context,width: 0.8)
                ),
              ),
            child: Padding(padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: child,),
          ),
        ),
        if (selectIndex != index) Gaps.empty else _buildGoodsMenu(context),
      ],
    );
  }
}

class _GoodsItemTag extends StatelessWidget {
  const _GoodsItemTag({
    required this.color,
    required this.text,
  });

  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      margin: EdgeInsets.only(right: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.0),
      ),
      height: 16.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.font_sp10,
            height: Device.isAndroid ? 1.1 : null),
      ),
    );
  }
}
