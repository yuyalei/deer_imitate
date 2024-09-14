import 'package:deer_imitate/goods/page/goods_page.dart';
import 'package:deer_imitate/goods/provider/goods_sort_provider.dart';
import 'package:deer_imitate/goods/widgets/goods_sort_bottom_sheet.dart';
import 'package:deer_imitate/res/resources.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/utils/image_utils.dart';
import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:deer_imitate/widgets/my_app_bar.dart';
import 'package:deer_imitate/widgets/my_button.dart';
import 'package:deer_imitate/widgets/my_scroll_view.dart';
import 'package:deer_imitate/widgets/text_field_item.dart';
import 'package:flutter/material.dart';

import '../../res/gaps.dart';
import '../../widgets/click_item.dart';

class GoodsEditPage extends StatefulWidget{
  final bool isAdd;
  final bool isScan;
  final String? hereTag;
  final String? goodsImageUrl;

  GoodsEditPage({super.key,this.isAdd = true, this.isScan = false, this.hereTag, this.goodsImageUrl});

  @override
  State<StatefulWidget> createState() {
    return _GoodsEditPageState();
  }

}

class _GoodsEditPageState extends State<GoodsEditPage>{
  String? _goodsSortName;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: widget.isAdd ? '添加商品':'编辑商品',
      ),
      body: MyScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        bottomButton: Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16,bottom: 8.0),
          child: MyButton(
              onPressed: () => NavigatorUtils.goBack(context),
            text: '提交',
          ),
        ),
        children: [
          Gaps.vGap5,
          const Padding(padding: EdgeInsets.only(left: 16),
          child: Text(
            '基本信息',
            style: TextStyles.textBold18,
          ),
          ),
          Gaps.vGap16,
          Center(
            child: LoadAssetImage('none'),
          ),
          Gaps.vGap16,
          const TextFieldItem(
            title: '商品名称',
            hintText: '填写商品名称',
          ),
          const TextFieldItem(
            title: '商品简介',
            hintText: '填写简短描述',
          ),
          const TextFieldItem(
            title: '折后价格',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            hintText: '填写商品单品折后价格',
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFieldItem(
                  controller: _codeController,
                title: '商品条码',
                hintText: '选填',
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: context.isDark?
                      const LoadAssetImage('goods/icon_sm', width: 16.0, height: 16.0) :
                      const LoadAssetImage('goods/scanning', width: 16.0, height: 16.0),
                  ),
                ),
              )
            ],
          ),
          const TextFieldItem(
            title: '商品说明',
            hintText: '选填',
          ),
          Gaps.vGap32,
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '折扣立减',
              style: TextStyles.textBold18,
            ),
          ),
          Gaps.vGap16,
          const TextFieldItem(
              title: '立减金额',
              keyboardType: TextInputType.numberWithOptions(decimal: true)
          ),
          const TextFieldItem(
              title: '折扣金额',
              keyboardType: TextInputType.numberWithOptions(decimal: true)
          ),
          Gaps.vGap32,
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '类型规格',
              style: TextStyles.textBold18,
            ),
          ),
          Gaps.vGap16,
          ClickItem(
            title: '商品类型',
            content: _goodsSortName ?? '选择商品类型',
            onTap: () => _showBottomSheet(),
          ),
          ClickItem(
            title: '商品规格',
            content: '对规格进行编辑',
            onTap: (){},
          ),
          Gaps.vGap8,
        ],
      ),
    );
  }

  final GoodsSortProvider _provider = GoodsSortProvider();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _showBottomSheet(){
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context){
          return GoodsSortBottomSheet(
              onSelected: (_,name){
                setState(() {
                  _goodsSortName = name;
                });
              },
              provider: _provider
          );
        }
    );
  }

}