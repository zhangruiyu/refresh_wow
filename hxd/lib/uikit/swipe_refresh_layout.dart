import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show required;

const Duration _kIndicatorScaleDuration = const Duration(milliseconds: 200);

enum _RefreshMode {
  upper, //上拉开始刷新
  lower, //下拉开始刷新
  armed, //到达合适位置
  snap, //执行
  drag, //开始拉动
  done, //刷新完成
  canceled, //用户取消
}

//回调
typedef Future<Null> RefreshCallback();

//子项被点击
typedef void OnItemClickListener(int index);

class SwipeRefreshLayout extends StatefulWidget {
  const SwipeRefreshLayout({
    Key key,
    @required this.onLoad,
    this.onLoadMore, //load more不添加也就是不需要上拉刷新
    this.backgroundColor,
    this.child,
  })
      : assert(onLoad != null),
        assert(child != null),
        super(key: key);

  //load
  final RefreshCallback onLoad;

  //load more
  final RefreshCallback onLoadMore;

  //background color
  final Color backgroundColor;

  final Widget child;

  final ScrollNotificationPredicate notificationPredicate =
      defaultScrollNotificationPredicate;

  @override
  SwipeRefreshLayoutState createState() => new SwipeRefreshLayoutState();
}

class SwipeRefreshLayoutState extends State<SwipeRefreshLayout>
    with TickerProviderStateMixin {
  final List<Widget> widgets = <Widget>[];

  _RefreshMode _mode = _RefreshMode.canceled;
  double _dragOffset = 0.0;
  bool _running = false;
  AnimationController _loadAlphaController;
  Animation<double> _loadAlphaFactor;
  Animation<double> _value; //circular progress indicator
  AnimationController _loadMoreAlphaController;
  Animation<double> _loadMoreAlphaFactor;
  Animation<double> _valueMore; //circular progress indicator

  @override
  void initState() {
    super.initState();
    _loadAlphaController = new AnimationController(vsync: this);
    _loadAlphaFactor = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    )
        .animate(_loadAlphaController);

    _value = new Tween<double>(
      begin: 0.0,
      end: 0.75,
    )
        .animate(_loadAlphaController);

    if (widget.onLoadMore != null) {
      _loadMoreAlphaController = new AnimationController(vsync: this);
      _loadMoreAlphaFactor = new Tween<double>(
        begin: 0.0,
        end: 1.0,
      )
          .animate(_loadMoreAlphaController);

      _valueMore = new Tween<double>(
        begin: 0.0,
        end: 0.75,
      )
          .animate(_loadMoreAlphaController);
    }
  }

  @override
  void dispose() {
    _loadAlphaController.dispose();
    if (_loadMoreAlphaController != null) _loadMoreAlphaController.dispose();
    super.dispose();
  }

  void _update(_RefreshMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  void _run(bool running) {
    _running = running;
  }

  //true:upper false:lower
  void _start(bool upper) {
    _run(true);
    AnimationController current;
    _RefreshMode mode;
    if (upper) {
      mode = _RefreshMode.upper;
      current = _loadAlphaController;
    } else {
      mode = _RefreshMode.lower;
      current = _loadMoreAlphaController;
    }
    final Completer<Null> completer = new Completer<Null>();
    _mode = _RefreshMode.snap;
    current
        .animateTo(1.0, duration: _kIndicatorScaleDuration)
        .then<void>((Null value) {
      if (mounted && _mode == _RefreshMode.snap) {
        assert(widget.onLoad != null);
        _update(mode);
        Future<Null> refresh = upper ? widget.onLoad() : widget.onLoadMore();
        assert(() {
          if (refresh == null)
            FlutterError.reportError(new FlutterErrorDetails(
              exception: new FlutterError(
                  'The onRefresh callback returned null.\n'
                      'The RefreshIndicator onRefresh callback must return a Future.'),
              context: 'when calling onRefresh',
              library: 'material library',
            ));
          return true;
        }());
        if (refresh == null) return;
        refresh.whenComplete(() {
          if (mounted && _mode == _RefreshMode.upper ||
              _mode == _RefreshMode.lower) {
            completer.complete();
            _dismiss(_RefreshMode.done);
          }
        });
      }
    });
  }

  Future<Null> _dismiss(_RefreshMode mode) async {
    _update(mode);
    if (_dragOffset > 0) {
      await _loadAlphaController.animateTo(0.0,
          duration: _kIndicatorScaleDuration);
    } else {
      if (_loadMoreAlphaController != null)
        await _loadMoreAlphaController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
    }
    if (mounted && _mode == mode) {
      _dragOffset = null;
      _update(null);
      new Timer(new Duration(milliseconds: 300), () {
        _run(false);
      });
    }
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (_loadMoreAlphaController == null &&
        (notification.depth != 0 || !notification.leading)) return false;
    if (_mode == _RefreshMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) return false;
    if (_running) return false;
    if (notification is ScrollStartNotification) {
      _dragOffset = 0.0;
      _mode = _RefreshMode.drag;
      return false;
    } else if (notification is ScrollUpdateNotification) {
      if (!notification.metrics.atEdge) return false;
      //这里是ios(测试发现当当前list占满屏幕时刷新会出现位置错误问题)
      if (_mode == _RefreshMode.drag || _mode == _RefreshMode.armed) {
        _dragOffset -= notification.scrollDelta;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is OverscrollNotification && !_running) {
      if (!notification.metrics.atEdge) return false;
      //这里是android(目前测试没问题)
      if (_mode == _RefreshMode.drag || _mode == _RefreshMode.armed) {
        _dragOffset -= notification.overscroll / 2.0;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification && !_running) {
      switch (_mode) {
        case _RefreshMode.armed:
          if (_dragOffset > 0) {
            _start(true);
          } else if (_dragOffset < 0 && _loadMoreAlphaController != null) {
            _start(false);
          }
          break;
        case _RefreshMode.drag:
          _dismiss(_RefreshMode.canceled);
          break;
        default:
          break;
      }
    }

    return false;
  }

  void _checkDragOffset(double extent) {
    double newValue = _dragOffset.abs() / (extent * 0.25);
    if (_mode == _RefreshMode.upper || _mode == _RefreshMode.lower)
      newValue = math.max(newValue, 1.0 / 1.5);
    newValue = newValue.clamp(0.0, 1.0);
    if (_dragOffset > 0) {
      _loadAlphaController.value = newValue;
    } else if (_dragOffset < 0 && _loadMoreAlphaController != null) {
      _loadMoreAlphaController.value = newValue;
    }

    //拖拽达到合适距离
    if (_mode == _RefreshMode.drag && newValue == 1.0)
      _mode = _RefreshMode.armed;
  }

  @override
  Widget build(BuildContext context) {
    final bool showIndeterminateIndicator = _mode == _RefreshMode.upper ||
        _mode == _RefreshMode.lower ||
        _mode == _RefreshMode.done;

    return new Stack(children: <Widget>[
      new NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: new NotificationListener<OverscrollIndicatorNotification>(
            onNotification: _handleGlowNotification,
            child: widget.child,
          )),
      new Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 20.0),
        child: new FadeTransition(
          opacity: _loadAlphaFactor,
          child: new AnimatedBuilder(
              animation: _loadAlphaController,
              builder: (BuildContext context, Widget index) {
                return new RefreshProgressIndicator(
                  value: showIndeterminateIndicator ? null : _value.value,
                  backgroundColor: widget.backgroundColor,
                );
              }),
        ),
      ),
      _loadMoreAlphaController == null
          ? new Container()
          : new Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: new FadeTransition(
          opacity: _loadMoreAlphaFactor,
          child: new AnimatedBuilder(
              animation: _loadMoreAlphaController,
              builder: (BuildContext context, Widget index) {
                return new RefreshProgressIndicator(
                  value: showIndeterminateIndicator
                      ? null
                      : _valueMore.value,
                  backgroundColor: widget.backgroundColor,
                );
              }),
        ),
      )
    ]);
  }
}