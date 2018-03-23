import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:refresh_wow/refresh_config.dart';

enum _RefreshIndicatorState {
  refresh,
  error,
  done,
}

class LoadMoreWidget extends StatefulWidget {
  final RefreshCallback onLoadMore;

  LoadMoreWidget(this.onLoadMore);

  @override
  State<StatefulWidget> createState() => new LoadMoreWidgetState();

}

class LoadMoreWidgetState extends State<LoadMoreWidget> {
  var currentState = _RefreshIndicatorState.refresh;

  @override
  void initState() {
    super.initState();
    if (widget.onLoadMore == null) {
      setState(() {
        currentState = _RefreshIndicatorState.done;
      });
    } else {
      final Future<Null> refreshResult = widget.onLoadMore();
      assert(() {
        if (refreshResult == null)
          FlutterError.reportError(new FlutterErrorDetails(
            exception: new FlutterError(
                'The onRefresh callback returned null.\n'
                    'The RefreshIndicator onRefresh callback must return a Future.'
            ),
            context: 'when calling onLoadMore',
            library: 'refresh_wow library',
          ));
        return true;
      }());
      refreshResult.catchError((f) {
        setState(() {
          currentState = _RefreshIndicatorState.error;
        });
      }).then((onValue) {
        if (mounted && currentState == _RefreshIndicatorState.refresh) {
          setState(() {
            currentState = _RefreshIndicatorState.done;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: currentState == _RefreshIndicatorState.refresh
          ?
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new SizedBox.fromSize(
            child: new CircularProgressIndicator(strokeWidth: 2.5),
            size: new Size.square(20.0),)
          ,
          new Padding(padding: const EdgeInsets.only(left: 7.0),
            child: new Text(new RefreshConfig().refreshingShowText),
          )

        ],

      )
          : currentState == _RefreshIndicatorState.error ? new FlatButton(
          child: new SizedBox(
              width: ui.window.physicalSize.width / ui.window.devicePixelRatio,
              child: new Text(new RefreshConfig().errShowText,
                  textAlign: TextAlign.center,
                  style: new TextStyle().merge(
                      new RefreshConfig().loadMoreTextStyle))
          ),
          onPressed: () {
            setState(() {
              currentState = _RefreshIndicatorState.refresh;
            });
            widget.onLoadMore();
          }) :
      new Text(new RefreshConfig().doneShowText),

    );
  }

}