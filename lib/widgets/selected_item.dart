import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/res/resources.dart';
import 'package:flutter/material.dart';

class SelectedItem extends StatelessWidget{
  final GestureTapCallback? onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle? textStyle;


  SelectedItem({
    super.key,
    this.onTap,
    required this.title,
    this.content = '',
    this.textAlign = TextAlign.start, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.0,
        margin: const EdgeInsets.only(right: 8.0,left: 8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(context,width: 0.6),
          )
        ),
        child: Row(
          children: [
            Text(title),
            Gaps.hGap16,
            Expanded(
                child: Text(
                  content,
                  maxLines: 2,
                  textAlign: textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                )
            ),
            Gaps.hGap8,
            Images.arrowRight
          ],
        ),
      ),
    );
  }

}