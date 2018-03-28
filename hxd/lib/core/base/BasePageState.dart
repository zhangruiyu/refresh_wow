import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hxd/core/base/BasePageRoute.dart';

class LifecycleInterface {}

LifecycleInterface lifecycleInterface = new LifecycleInterface();
LinkedHashMap<String, Widget> allPageInstance =
    new LinkedHashMap<String, Widget>();

abstract class BasePageState<T extends BasePageRoute>
    extends State<T> /*with WidgetsBindingObserver*/ {
  final GlobalKey<ScaffoldState> scaffoldStateKey =
      new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    print('BasePageState===$this');
    //执行关闭页面回调
    if (widget.props != null && widget.props.containsKey('cbk')) {
      widget.props['cbk']();
    }
  }
}
