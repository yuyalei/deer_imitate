import 'package:deer_imitate/res/gaps.dart';
import 'package:deer_imitate/utils/input_formatter/number_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldItem extends StatelessWidget{

  const TextFieldItem({super.key,this.controller, required this.title, this.hintText = '', this.keyboardType = TextInputType.text,
      this.focusNode});

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final Row child = Row(
      children: [
        Text(title),
        Gaps.hGap16,
        Expanded(
            child: TextField(
              focusNode: focusNode,
              keyboardType: keyboardType,
              inputFormatters: _getInputFormatters(),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none
              ),
            ),
        ),
        Gaps.hGap16
      ],
    );

    return Container(
      height: 50.0,
      margin: const EdgeInsets.only(left: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context,width: 0.8),
        ),
      ),
      child: child,
    );
  }

  List<TextInputFormatter>? _getInputFormatters(){
    if(keyboardType == const TextInputType.numberWithOptions(decimal: true)){
      return <TextInputFormatter>[UsNumberTextInputFormatter()];
    }
    if(keyboardType == TextInputType.number || keyboardType == TextInputType.phone){
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    }
  }
}