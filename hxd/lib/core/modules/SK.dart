import 'package:flutter/material.dart';
import 'package:hxd/core/modules/home/homeTab.dart';

class SK {
  //主页面state
  static final GlobalKey<BottomNavigationDemoState> bottomNavigationDemoStateKey =
  new GlobalKey<BottomNavigationDemoState>();
  //动态列表页state
  static final GlobalKey<RefreshIndicatorState> dynamicRefreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>(); //动态列表页state
  static final GlobalKey<RefreshIndicatorState> homepageRefreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  static final GlobalKey<RefreshIndicatorState> bidListRefreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  //账户页面整个state
//  static final GlobalKey<AccountPageState> accountPageStateKey =
//  new GlobalKey<AccountPageState>();
}
