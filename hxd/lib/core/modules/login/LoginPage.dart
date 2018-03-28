import 'package:flutter/material.dart';
import 'package:hxd/core/base/BasePageRoute.dart';
import 'package:hxd/core/base/BasePageState.dart';

class LoginPage extends BasePageRoute {
  static const String routeName = '/LoginPage';

  static start(context, props) {
    Navigator.of(context).push(new MaterialPageRoute<bool>(
      builder: (BuildContext context) {
        return new LoginPage(props);
      },
    ));
  }

  LoginPage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends BasePageState<LoginPage> {
  String tel = '15201231805';

  void _login() async {
    if (tel.length < 11) {}
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
        body: new Container(
          margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
          child: new Column(children: <Widget>[

            // onSubmitted：当用户在键盘上点击完成编辑时调用
          ]),
        ));
  }
}
