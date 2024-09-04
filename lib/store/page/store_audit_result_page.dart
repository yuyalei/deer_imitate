import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../routers/routers.dart';
import '../../widgets/load_image.dart';
import '../../widgets/my_button.dart';

class StoreAuditResultPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _StoreAuditResultPageState();
  }

  const StoreAuditResultPage({super.key});
}

class _StoreAuditResultPageState extends State<StoreAuditResultPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '审核结果',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Gaps.vGap50,
            const LoadAssetImage('store/icon_success',
              width: 80.0,
              height: 80.0,
            ),
            Gaps.vGap12,
            const Text(
              '恭喜，店铺资料审核成功',
              style: TextStyles.textSize16,
            ),
            Gaps.vGap8,
            Text(
              '2021-02-21 15:20:10',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Gaps.vGap8,
            Text(
              '预计完成时间：02月28日',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Gaps.vGap24,
            MyButton(
              onPressed: () {
                NavigatorUtils.push(context, Routes.home, clearStack: true);
              },
              text: '进入',
            )
          ],
        ),
      ),
    );
  }
}
