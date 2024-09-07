import 'package:flutter/material.dart';

class GoodsPageProvider extends ChangeNotifier{

  /// 选中商品分类下标
  int _sortIndex = 0;
  int get sortIndex => _sortIndex;

  void setSortIndex(int sortIndex){
    _sortIndex = sortIndex;
    notifyListeners();
  }
}