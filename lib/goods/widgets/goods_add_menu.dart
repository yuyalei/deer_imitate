import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../routers/fluro_navigator.dart';
import '../goods_router.dart';

class GoodsAddMenu extends StatefulWidget {
  const GoodsAddMenu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GoodsAddMenuState();
  }
}

class _GoodsAddMenuState extends State<GoodsAddMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = context.backgroundColor;
    final Color? iconColor = ThemeUtils.getIconColor(context);
    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: LoadAssetImage('goods/jt',
              width: 8.0,
              height: 4.0,
              color: ThemeUtils.getDarkColor(context, Colours.dark_bg_color)),
        ),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(
              onPressed: (){

              },
              icon: LoadAssetImage('goods/scanning', width: 16.0, height: 16.0, color: iconColor,),
              style: TextButton.styleFrom(
                foregroundColor:  Theme.of(context).textTheme.bodyMedium?.color,
                disabledForegroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.12),
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0))
                )
              ),
              label: Text("扫码添加")
          ),
        ),
        Container(width: 120,height: 0.5,color: Colours.line,),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(onPressed: (){ NavigatorUtils.push(context, '${GoodsRouter.goodsEditPage}?isAdd=true&isScan=true', replace: true);},
            icon: LoadAssetImage('goods/add2', width: 16.0, height: 16.0, color: iconColor,),
              label: Text("添加商品"),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
            disabledForegroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.12),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))
            )
          ),),
        )
      ],
    );

    return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (_,child){
          return Transform.scale(
            scale: _scaleAnimation.value,
            alignment: Alignment.topRight,
            child: body,
          );
        });
  }
}
