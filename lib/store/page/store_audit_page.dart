import 'package:deer_imitate/res/resources.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/widgets/my_app_bar.dart';
import 'package:deer_imitate/widgets/my_button.dart';
import 'package:deer_imitate/widgets/my_scroll_view.dart';
import 'package:deer_imitate/widgets/text_field_item.dart';
import 'package:flutter/material.dart';

import '../../res/gaps.dart';
import '../../widgets/load_image.dart';
import '../../widgets/selected_item.dart';

class StoreAuditPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StoreAuditPageState();
  }

  const StoreAuditPage({super.key});
}

class _StoreAuditPageState extends State<StoreAuditPage> {
  String _address = '陕西省 西安市 雁塔区 高新六路201号';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "店铺审核资料",
      ),
      body: MyScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 15),
          bottomButton: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 8.0),
            child: MyButton(
              onPressed: () {

              },
              text: "提交",
            ),
          ),
          children: _buildBody()
      ),
    );
  }

  List<Widget> _buildBody() {
    return [
      Gaps.vGap5,
      const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Text('店铺资料', style: TextStyles.textBold18,),
      ),
      Gaps.vGap16,
      Center(
        child: LoadAssetImage('store/icon_zj',
          width: 80.0,
          height: 80.0,
        ),
      ),
      Gaps.vGap10,
      Center(
        child: Text(
          '店主手持身份证或营业执照',
          style: Theme
              .of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: Dimens.font_sp14),
        ),
      ),
      Gaps.vGap16,
      TextFieldItem(
          title: '店铺名称',
          hintText: '填写店铺名称'
      ),
      SelectedItem(
          title: '主营范围',
          content: _sortName,
          onTap: () => _showBottomSheet()
      ),
      SelectedItem(
        title: '店铺地址',
        content: _address,
      ),
      Gaps.vGap32,
      const Padding(
        padding:EdgeInsets.only(left: 16.0),
        child: Text('店主信息',style: TextStyles.textBold16,),
      ),
      Gaps.vGap16,
      TextFieldItem(
          title: '店主姓名',
          hintText: '填写店主姓名'
      ),
      TextFieldItem(
          keyboardType: TextInputType.phone,
          title: '联系电话',
          hintText: '填写店主联系电话'
      )
    ];
  }

  String _sortName = '';
  final List<String> _list = [
    '水果生鲜',
    '家用电器',
    '休闲食品',
    '茶酒饮料',
    '美妆个护',
    '粮油调味',
    '家庭清洁',
    '厨具用品',
    '儿童玩具',
    '床上用品'
  ];

  void _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.6,
          expand: false,
          builder: (_, scrollController) {
            return ListView.builder(
                controller: scrollController,
                itemExtent: 48.0,
                itemBuilder: (_, index) {
                  return InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(_list[index]),
                    ),
                    onTap: () {
                      setState(() {
                        _sortName = _list[index];
                      });
                      NavigatorUtils.goBack(context);
                    },
                  );
                },
              itemCount: _list.length,
            );
          },
        );
      },
    );
  }
}