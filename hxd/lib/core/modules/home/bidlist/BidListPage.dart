import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hxd/core/base/BasePageRoute.dart';
import 'package:hxd/core/base/BasePageState.dart';
import 'package:hxd/core/modules/home/bidlist/BidListItem.dart';
import 'package:hxd/net/RequestHelper.dart';
import 'package:hxd/utils/WindowUtils.dart';

class BidListPage extends BasePageRoute {
  BidListPage([Map<String, String> props]) : super(props);

//  final HomePageState homePageState = new HomePageState();

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends BasePageState<BidListPage> {
  refreshPage() async {
    _handleRefresh().then((onValue) {});
  }

  @override
  void initState() {
    super.initState();
//    refreshPage();
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getHomepage().then((data) {
      /*setState(() {
        bannerData = data['data'];
        var addition = data['addition'];
        if (addition > 0) {
          Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("每日登陆积分 +$addition"),
              backgroundColor: Theme.of(context).accentColor));
        }
      });*/
      completer.complete(null);
    }).catchError((onError) {
      completer.complete(null);
      print(onError);
//      setState(() {});
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new HomeBidViewWidget();
  }
}

class _Page {
  _Page({this.label, this.type});

  final String label;
  final String type;

  String get id => label[0];

  @override
  String toString() => '$runtimeType("$label")';
}

class HomeBidViewWidget extends StatelessWidget {
  HomeBidViewWidget({this.data});

  final data;

  final List<_Page> _allPages = [
    new _Page(
      label: '踏实赚',
      type: '1',
    ),
    new _Page(
      label: '自由赚',
      type: '2',
    ),
    new _Page(
      label: '散标',
      type: '3',
    ),
    new _Page(
      label: '债权转让',
      type: '4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var indicatorWidth = (WindowUtils.getScreenWidth() / 4 - 14) / 2;
    return new DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: new SliverAppBar(
                  backgroundColor: const Color(0xffffffff),
                  primary: false,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: new TabBar(
                    labelColor: const Color(0xffe71d36),
                    unselectedLabelColor: const Color(0xff313131),
                    labelStyle: new TextStyle(color: const Color(0xff000000)),
                    unselectedLabelStyle:
                        new TextStyle(color: const Color(0xff000000)),
                    indicatorPadding: new EdgeInsets.only(
                        left: indicatorWidth,
                        right: indicatorWidth,
                        bottom: 5.0),
                    tabs: _allPages
                        .map(
                          (_Page page) => new Tab(text: page.label),
                        )
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: new TabBarView(
              children: _allPages.map((page) {
            return new SafeArea(
              top: false,
              bottom: false,
              child: new Builder(
                builder: (BuildContext context) {
                  return new CustomScrollView(
                    key: new PageStorageKey<_Page>(page),
                    slivers: <Widget>[
                      new SliverOverlapInjector(
                        handle: NestedScrollView
                            .sliverOverlapAbsorberHandleFor(context),
                      ),
                      new SliverList(
                        delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            print(index);
                            return new BidListItem();
                          },
                          childCount: 100,
                        ),
                      ),
                      /*  new ListView.custom(childrenDelegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return new Text('aaa');
                        },
                        childCount: 200,
                      ),)*/
                    ],
                  );
                },
              ),
            );
          }).toList()),
        ),
      ),
    );
  }
}
