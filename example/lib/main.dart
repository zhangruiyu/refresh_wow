import 'dart:async';

import 'package:flutter/material.dart';
import 'package:refresh_wow/refresh_wow.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

Iterable<int> get positiveIntegers sync* {
  int i = 0;
  while (true) yield i++;
}

class _MyHomePageState extends State<MyHomePage> {

  List<String>list = positiveIntegers
      .skip(1) // don't use 0
      .take(100) // take 10 numbers
      .toList().map((i) => "我是初始数据$i").toList();
  bool hasMore = false;

  Future<Null> _handleRefresh() {
    print('_handleRefresh');
    final Completer<Null> completer = new Completer<Null>();
    new Timer(new Duration(milliseconds: 500), () {
      setState(() {
        list = positiveIntegers
            .skip(1) // don't use 0
            .take(100) // take 10 numbers
            .toList().map((i) => "我是初始数据$i").toList();
      });

      completer.complete(null);
    });
    return completer.future;
  }

  int error = 0;

  Future<Null> _handleLoadMore() {
    print('_handleLoadMore');
    final Completer<Null> completer = new Completer<Null>();
    new Timer(new Duration(milliseconds: 1300), () {
      //error模拟失败
      if (error != 1) {
        setState(() {
          error++;
          list.addAll(positiveIntegers
              .skip(1) // don't use 0
              .take(70) // take 10 numbers
              .toList().map((i) => "我是更多数据$i").toList());
          hasMore = list.length > 300;
        });
        completer.complete(null);
      } else {
        error++;
        completer.completeError(null);
//        throw new Exception('获取数据失败');
      }
    });
    return completer.future;
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: new RefreshListView(
          itemData: this.list,
          footerItemCount: 2,
          headerItemCount: 2,
          itemBuilder: (BuildContext context, int index, String itemData) {
            return new Text('itemData: $itemData index: $index');
          },
          headerBuilder: (BuildContext context, int index) {
            return new Text('header: $index');
          },
          footerBuilder: (BuildContext context, int index) {
            return new Text('footer: $index');
          },
          onRefresh: _handleRefresh,
          onLoadMore: !hasMore ? _handleLoadMore : null,)
    );
  }
}
