import 'package:flutter/material.dart';
import 'package:hxd/core/base/BasePropsWidget.dart';

abstract class BasePropsState<T extends BasePropsWidget> extends State<T> {
/*
  @override
  void dispose() {
    super.dispose();
    print('BasePageState===$this');
    //执行关闭页面回调
    if (props != null && props.containsKey('cbk')) {
      props['cbk']();
    }
  }*/
}
