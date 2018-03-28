import 'dart:async';

import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hxd/core/base/BasePageRoute.dart';
import 'package:hxd/core/base/BasePageState.dart';
import 'package:hxd/core/modules/SK.dart';
import 'package:hxd/net/RequestHelper.dart';
import 'package:hxd/utils/WindowUtils.dart';

class HomePage extends BasePageRoute {
  HomePage([Map<String, String> props]) : super(props);

//  final HomePageState homePageState = new HomePageState();

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends BasePageState<HomePage> {
  static List bannerData = [
    {
      'picUrl':
          'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2882284884,1913504836&fm=27&gp=0.jpg',
    },
    {
      'picUrl':
          'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2882284884,1913504836&fm=27&gp=0.jpg'
    }
  ];

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
    return new RefreshIndicator(
        key: SK.homepageRefreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: new SingleChildScrollView(
            physics: new AlwaysScrollableScrollPhysics(),
            child: new Column(
              children: <Widget>[
                Stack(
                  children:[
                    new BannerView(
                      data: bannerData,
                      buildShowView: (index, data) {
                        return new BannerShowWidget(data: data);
                      },
                      onBannerClickListener: (index, data) {
//                    getImage();
                      },
                    ),
                    new Row(
                      children: <Widget>[
//                        new Image.asset(name)
                      ],
                    ),
                  ]
                ),
                new HomeBidViewWidget(),
                new HomeBidViewWidget(),
                new HomeBidViewWidget(),
                new HomeBidViewWidget(),
              ],
            )));
  }
}

class HomeBidViewWidget extends StatelessWidget {
  HomeBidViewWidget({this.data});

  final data;

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 19.5, right: 16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new RichText(
              text: new TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  new TextSpan(
                      text: '自由赚', style: new TextStyle(fontSize: 16.0)),
                  new TextSpan(
                      text: '    您的资金你做主',
                      style: new TextStyle(
                          color: const Color(
                            0xffBBBBBB,
                          ),
                          fontSize: 12.0))
                ],
              ),
            ),
            new Padding(
                padding: const EdgeInsets.only(right: 70.0, top: 9.5),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text('8%+7%',
                        style: new TextStyle(
                            fontSize: 24.0, color: const Color(0xffe71d36))),
                    new Row(
                      children: <Widget>[
                        new Container(
                          child: new Container(
                            height: 40.0,
                            margin: new EdgeInsetsDirectional.only(
                                end: 45.0, top: 10.0),
                            decoration: new BoxDecoration(
                              border: new Border(
                                left: new BorderSide(
                                  color: const Color(0xffeeeeee),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        new Text('1个月',
                            style: new TextStyle(
                              fontSize: 16.0,
                            )),
                      ],
                    )
                  ],
                )),
            new Padding(
                padding:
                    const EdgeInsets.only(bottom: 7.0, top: 6.0, right: 72.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text('预期年化收益率',
                        style: new TextStyle(
                            fontSize: 12.0, color: const Color(0xff999999))),
                    new Text('锁定期',
                        style: new TextStyle(
                            fontSize: 12.0, color: const Color(0xff999999))),
                  ],
                )),
            new Divider(color: const Color(0xffeeeeee))
          ],
        ));
  }
}

class BannerShowWidget extends StatelessWidget {
  BannerShowWidget({this.data});

  final data;

  @override
  Widget build(BuildContext context) {
    return new CachedNetworkImage(
      imageUrl: data['picUrl'],
      errorWidget: new Icon(Icons.error),
      fit: BoxFit.fill,
      width: WindowUtils.getScreenWidth(),
    );
  }
}
