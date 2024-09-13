import 'package:deer_imitate/res/colors.dart';
import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:deer_imitate/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../../res/dimens.dart';

class MySearchBar extends StatefulWidget implements PreferredSizeWidget{
  final String backImg;
  final String hintText;
  final void Function(String)? onPressed;

  MySearchBar({super.key,this.backImg ='assets/images/ic_back_black.png', this.hintText = '', this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return _MySearchBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);

}
class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = context.isDark ? Colours.dark_text_gray : Colours.text_gray_c;
    final Widget back = SizedBox(
      width: 48.0,
      height: 48.0,
      child: InkWell(
        onTap: (){
          _focusNode.unfocus();
          Navigator.maybePop(context);
        },
        borderRadius: BorderRadius.circular(24.0),
        child: Padding(
            padding: EdgeInsets.all(12.0),
          child: Image.asset(
            widget.backImg,
            color: context.isDark ? Colours.dark_text : Colours.text,
          ),
        ),
      ),
    );

    final Widget textField = Expanded(
        child: Container(height: 32.0,
        decoration: BoxDecoration(
          color: context.isDark ? Colours.dark_material_bg: Colours.bg_gray,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (String val){
            _focusNode.unfocus();
            widget.onPressed?.call(val);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: -8.0, right: -42.0, bottom: 10.0),
            border: InputBorder.none,
            icon: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
              child: LoadAssetImage('order/order_search', color: iconColor,),
            ),
            hintText: widget.hintText,
            suffixIcon: GestureDetector(
              child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: LoadAssetImage('order/order_delete', color: iconColor),
              ),
              onTap: (){
                _controller.text = '';
              },
            ),
          ),
        ),
        )
    );

    final Widget search = MyButton(
      minHeight: 32.0,
        minWidth: 44,
        fontSize: Dimens.font_sp14,
        radius: 4.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        text: '搜索',
        onPressed: (){
          _focusNode.unfocus();
          widget.onPressed?.call(_controller.text);
        }
    );

    return Material(
      color: context.backgroundColor,
      child: SafeArea(
          child: Row(
            children: [back,textField,Gaps.hGap8,search,Gaps.hGap16],
          )
      ),
    );
  }

}