import 'package:common_utils/common_utils.dart';
import 'package:deer_imitate/order/widgets/pay_type_dialog.dart';
import 'package:deer_imitate/res/dimens.dart';
import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/utils/other_utils.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../res/styles.dart';
import '../../routers/fluro_navigator.dart';
import '../../utils/toast_utils.dart';
import '../../widgets/my_card.dart';
import '../order_router.dart';

const List<String> orderLeftButtonText = ['拒单', '拒单', '订单跟踪', '订单跟踪', '订单跟踪'];
const List<String> orderRightButtonText = ['接单', '开始配送', '完成', '', ''];

class OrderItem extends StatelessWidget{
  const OrderItem({
    super.key,
    required this.tabIndex,
    required this.index,
  });

  final int tabIndex;
  final int index;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: MyCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => NavigatorUtils.push(context, OrderRouter.orderInfoPage),
              child: _buildContent(context),
            ),
          ),
        )
    );
  }

  Widget _buildContent(BuildContext context) {
    final TextStyle? textTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimens.font_sp12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text('15000000000（郭李）'),
            ),
            Text(
              '货到付款',
              style: TextStyle(
                fontSize: Dimens.font_sp12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        Gaps.vGap8,
        Text(
          '西安市雁塔区 鱼化寨街道唐兴路唐兴数码3楼318',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              const TextSpan(text: '清凉一度抽纸'),
              TextSpan(text: '  x1', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              const TextSpan(text: '清凉一度抽纸'),
              TextSpan(text: '  x2', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
        Gaps.vGap12,
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTextStyle,
                  children: <TextSpan>[
                    TextSpan(text: Utils.formatPrice('20.00', format: MoneyFormat.NORMAL)),
                    TextSpan(text: '  共3件商品', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Dimens.font_sp10)),
                  ],
                ),
              ),
            ),
            const Text(
              '2021.02.05 10:00',
              style: TextStyles.textSize12,
            ),
          ],
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        Row(
          children: <Widget>[
            OrderItemButton(
              key: Key('order_button_1_$index'),
              text: '联系客户',
              textColor: Colours.text,
              bgColor:  Colours.bg_gray,
              onTap: () => _showCallPhoneDialog(context, '15000000000'),
            ),
            const Expanded(
              child: Gaps.empty,
            ),
            OrderItemButton(
              key: Key('order_button_2_$index'),
              text: orderLeftButtonText[tabIndex],
              textColor: Colours.text,
              bgColor: Colours.bg_gray,
              onTap: () {
                if (tabIndex >= 2) {

                }
              },
            ),
            if (orderRightButtonText[tabIndex].isEmpty) Gaps.empty else Gaps.hGap10,
            if (orderRightButtonText[tabIndex].isEmpty) Gaps.empty else OrderItemButton(
              key: Key('order_button_3_$index'),
              text: orderRightButtonText[tabIndex],
              textColor: Colors.white,
              bgColor: Colours.app_main,
              onTap: () {
                if (tabIndex == 2) {
                  _showPayTypeDialog(context);
                }
              },
            ),
          ],
        )
      ],
    );
  }
}

void _showCallPhoneDialog(BuildContext context, String phone){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: const Text('提示'),
          content: Text('是否拨打：$phone ?'),
          actions: [
            TextButton(
              onPressed: () => NavigatorUtils.goBack(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Utils.launchTelURL(phone);
                NavigatorUtils.goBack(context);
              },
              style: ButtonStyle(
                // 按下高亮颜色
                overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.error.withOpacity(0.2)),
              ),
              child: Text('拨打', style: TextStyle(color: Theme.of(context).colorScheme.error),),
            ),
          ],
        );
      }
  );
}

void _showPayTypeDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return PayTypeDialog(
          onPressed: (index,type){
            Toast.show('收款类型：$type');
          },
        );
      }
  );
}

class OrderItemButton extends StatelessWidget {

  const OrderItemButton({
    super.key,
    this.bgColor,
    this.textColor,
    required this.text,
    this.onTap
  });

  final Color? bgColor;
  final Color? textColor;
  final GestureTapCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: BoxConstraints(
          minWidth: 64.0,
          maxHeight: 30.0,
          minHeight: 30.0,
        ),
        child: Text(text,style: TextStyle(fontSize: Dimens.font_sp14, color: textColor)),
      ),
    );
  }
  
  
}
    