import 'package:flutter/material.dart';
import 'package:hxd/core/base/BasePropsState.dart';
import 'package:hxd/core/base/BasePropsWidget.dart';

class BidListItem extends BasePropsWidget {
  BidListItem([Map<String, String> props]) : super(props);

//  final HomePageState homePageState = new HomePageState();

  @override
  State<StatefulWidget> createState() {
    return BidListItemState();
  }
}

class BidListItemState extends BasePropsState<BidListItem> {
  @override
  void initState() {
    super.initState();
//    refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            border: new Border(
              bottom: new BorderSide(
                color: const Color(0xfff5f5f5),
                width: 10.0,
              ),
            ),
          ),
        ),
        Padding(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('踏实赚APL101012   '),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xffe71d36),
                        ),
                        child: Text(
                          '新手专享',
                          style: TextStyle(
                              color: const Color(0xffffffff), fontSize: 12.0),
                        ),
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 10.0, right: 10.0),
                      ),
                    ],
                  ),
                  Text('100日还款'),
                ],
              ),
              Divider(
                color: const Color(0xffe0e0e0),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 3.0,
                  bottom: 3.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Image.asset('images/common_jiangli_icon.png'),
                          Text(
                            '6%+9%  ',
                            style: TextStyle(
                              color: const Color(0xffe71d36),
                              fontSize: 22.0,
                            ),
                          ),
                        ],
                      ),
                      flex: 6,
                    ),
                    Flexible(
                      flex: 4,
                      child: Text('3个月     ',
                          style: TextStyle(
                            fontSize: 14.0,
                          )
                      ,textAlign: TextAlign.left,),
                    ),
                    Flexible(
                      child: FlatButton(
                        color: const Color(0xffe71d36),
                        textColor: const Color(0xffffffff),
                        child: Text('立即加入'),
                        onPressed: () {},
                      ),
                      flex: 5,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 3.0,
                  bottom: 3.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '预期收益年化利率',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      flex: 6,
                    ),
                    Flexible(
                      child: Text('锁定期限',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),textAlign: TextAlign.left,),
                      flex: 4,
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 60.0,
                            height: 4.0,
                            margin: const EdgeInsets.only(left: 25.0),
                            child: LinearProgressIndicator(),
                          ),
                          Text('81%',
                              style: TextStyle(
                                fontSize: 14.0,
                              )),
                        ],
                      ),
                      flex: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        ),
      ],
    );
  }
}
