import 'package:deer_imitate/res/dimens.dart';
import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/res/resources.dart';
import 'package:flutter/material.dart';

class ClickItem extends StatelessWidget{

  final GestureTapCallback? onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final int maxLine;
  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      crossAxisAlignment: maxLine == 1 ? CrossAxisAlignment.center:CrossAxisAlignment.start,
      children: [
        Text(title),
        const Spacer(),
        Text(
          content,
          maxLines: maxLine,
          textAlign: maxLine == 1 ? TextAlign.right : textAlign,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Dimens.font_sp14),
        ),
        Gaps.hGap8,
        Opacity(
            opacity: onTap == null ?0:1,
          child: Padding(
              padding: EdgeInsets.only(top: maxLine == 1?0.0:2.0),
            child: Images.arrowRight,
          ),
        )
      ],
    );

    child = Container(
      margin: EdgeInsets.only(left: 15.0),
      padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
      constraints: const BoxConstraints(
        minHeight: 50
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context,width: 0.6)
        )
      ),
      child: child,
    );

    return InkWell(
      onTap: onTap,
      child: child,
    );
  }

  ClickItem({this.onTap,required this.title, this.content = '', this.textAlign = TextAlign.start, this.maxLine = 1});

}