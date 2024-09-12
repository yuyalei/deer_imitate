
import 'package:deer_imitate/mvp/base_presenter.dart';
import 'package:deer_imitate/mvp/mvps.dart';
import 'package:deer_imitate/routers/fluro_navigator.dart';
import 'package:deer_imitate/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';

import '../utils/log_utils.dart';
import '../utils/toast_utils.dart';

mixin BasePageMixin<T extends StatefulWidget,P extends BasePresenter> on State<T> implements IMvpView{
  P? presenter;
  P createPresenter();
  bool _isShowDialog = false;

  @override
  BuildContext getContext() {
    return context;
  }

  @override
  void closeProgress() {
    if(mounted && _isShowDialog){
      _isShowDialog = false;
      NavigatorUtils.goBack(context);
    }
  }

  @override
  void showProgress() {
    if(mounted && !_isShowDialog){
      _isShowDialog = true;
      try{
        showDialog<void>(
            context: context,
            barrierDismissible: false,
            barrierColor: const Color(0x00FFFFFF),
            builder: (_){
              return PopScope(
                onPopInvokedWithResult: (didPop,dynamic){
                  _isShowDialog = false;
                  return ;
                },
                  child: buildProgress()
              );
            }
        );
      }catch(e){
        /// 异常原因主要是页面没有build完成就调用Progress。
        debugPrint(e.toString());
      }
    }
  }

  @override
  void showToast(String string) {
    Toast.show(string);
  }

  @override
  void didChangeDependencies() {
    presenter?.didChangeDependencies();
    Log.d('$T ==> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    presenter?.dispose();
    Log.d('$T ==> dispose');
    super.dispose();
  }

  @override
  void deactivate() {
    presenter?.deactivate();
    Log.d('$T ==> deactivate');
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    presenter?.didUpdateWidgets<T>(oldWidget);
    Log.d('$T ==> didUpdateWidgets');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    Log.d('$T ==> initState');
    presenter = createPresenter();
    presenter?.view = this;
    presenter?.initState();
    super.initState();
  }

  Widget buildProgress() => const ProgressDialog(hintText: '正在加载...',);
}