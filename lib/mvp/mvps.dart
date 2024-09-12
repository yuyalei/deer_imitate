import 'package:deer_imitate/mvp/i_lifecycle.dart';
import 'package:flutter/material.dart';

abstract class IMvpView{
  BuildContext getContext();
  void showProgress();
  void closeProgress();
  void showToast(String string);
}

abstract class IPresenter extends ILifecycle {}
