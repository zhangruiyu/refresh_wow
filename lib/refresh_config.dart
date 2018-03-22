import 'package:flutter/material.dart';


class RefreshConfig {
  static final RefreshConfig _singleton = new RefreshConfig._internal();

  factory RefreshConfig() {
    return _singleton;
  }

  RefreshConfig._internal();

  var pageSize = 10;
  var refreshingShowText = '正在刷新数据';
  var errShowText = '数据刷新失败\n点击重试';
  var doneShowText = '⁽⁽ଘ( ˊᵕˋ )ଓ⁾⁾';
  var loadMoreTextStyle = new TextStyle();
}
