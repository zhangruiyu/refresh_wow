import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hxd/core/constant/Constant.dart';
import 'package:hxd/core/modules/SK.dart';
import 'package:hxd/core/modules/home/NavigationPageView.dart';
import 'package:hxd/core/modules/home/bidlist/BidListPage.dart';
import 'package:hxd/core/modules/home/home/HomePage.dart';
import 'package:hxd/core/modules/login/LoginPage.dart';

class HomeTab extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  final ThemeData themeData;

  HomeTab(this.themeData) : super(key: SK.bottomNavigationDemoStateKey);

  @override
  State<StatefulWidget> createState() =>
      new BottomNavigationDemoState(themeData);
}

class BottomNavigationDemoState extends State<HomeTab>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationPageView> _navigationViews;
  ThemeData _themeData;

  BottomNavigationDemoState(ThemeData themeData) : _themeData = themeData;

  @override
  void initState() {
    super.initState();
    var accentBackgroundColors = _themeData.accentColor;

    _navigationViews = <NavigationPageView>[
      new NavigationPageView(
          icon: const Icon(Icons.home),
          title: '首页',
          color: const Color(0xffe71d36),
          vsync: this,
          content: new HomePage()),
      new NavigationPageView(
          icon: const Icon(Icons.notifications),
          title: '出借',
          color: accentBackgroundColors,
          vsync: this,
          content: new BidListPage({})),
      new NavigationPageView(
          icon: const Icon(Icons.notifications),
          title: '发现',
          color: accentBackgroundColors,
          vsync: this,
          content: new LoginPage({})),
      new NavigationPageView(
          icon: const Icon(Icons.menu),
          title: '账户',
          color: accentBackgroundColors,
          vsync: this,
          content: new LoginPage()),
    ];

    for (NavigationPageView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationPageView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  List<FadeTransition> transitions;

  Widget _buildTransitionsStack() {
    if (transitions == null) {
      transitions = <FadeTransition>[];

      for (NavigationPageView view in _navigationViews)
        transitions.add(view.transitionPage(_type, context));
    }

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });
    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationPageView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
          var currentView = _navigationViews[_currentIndex].content;
          /* new Timer(new Duration(milliseconds: 200), () {
            if (currentView is HomePage) {
              SK.homepageRefreshIndicatorKey.currentState?.show();
            } else if (currentView is DynamicPage) {
              SK.dynamicRefreshIndicatorKey.currentState?.show();
            } else if (currentView is AccountPage) {
              SK.accountPageStateKey.currentState?.refreshPage();
            }
          });*/
        });
      },
    );
    //初始页面未点击,但是首页需要数据
    new Timer(new Duration(milliseconds: refreshDelay), () {
      SK.homepageRefreshIndicatorKey.currentState?.show();
    });

    return new Scaffold(
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}
