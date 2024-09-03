import 'package:deer_imitate/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/state_layout.dart';

class NotFoundPage extends StatelessWidget {

  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        centerTitle: '页面不存在',
      ),
      body: StateLayout(
        type: StateType.account,
        hintText: '页面不存在',
      ),
    );
  }
}
