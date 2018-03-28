import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:hxd/core/modules/Routes.dart';
import 'package:hxd/core/modules/home/homeTab.dart';

final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  backgroundColor: const Color(0xffe71d36),
  accentColor: const Color(0xffe71d36),
  indicatorColor: const Color(0xffe71d36),
  scaffoldBackgroundColor:  const Color(0xffffffff),

);

final ThemeData _kGalleryDarkTheme = new ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    backgroundColor: const Color(0xffe71d36),
    accentColor: const Color(0xffe71d36));

class KindergartenApp extends StatefulWidget {
  const KindergartenApp(
      {this.enablePerformanceOverlay: true,
      this.checkerboardRasterCacheImages: true,
      this.checkerboardOffscreenLayers: true,
      this.onSendFeedback,
      Key key})
      : super(key: key);

  final bool enablePerformanceOverlay;

  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  final VoidCallback onSendFeedback;

  @override
  KindergartenAppState createState() => new KindergartenAppState();
}

class KindergartenAppState extends State<KindergartenApp> {
  bool _useLightTheme = true;
  bool _showPerformanceOverlay = false;
  bool _checkerboardRasterCacheImages = false;
  bool _checkerboardOffscreenLayers = false;
  TextDirection _overrideDirection = TextDirection.ltr;
  TargetPlatform _platform;

  // A null value indicates "use system default".
  double _textScaleFactor;

  Widget _applyScaleFactor(Widget child) {
    return new Builder(
      builder: (BuildContext context) => new MediaQuery(
            data: MediaQuery.of(context).copyWith(
                  textScaleFactor: _textScaleFactor,
                ),
            child: child,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget home = new HomeTab(Theme.of(context));

    final Map<String, WidgetBuilder> _kRoutes = <String, WidgetBuilder>{};
    for (GalleryItem item in kAllGalleryItems) {
      // For a different example of how to set up an application routing table
      // using named routes, consider the example in the Navigator class documentation:
      // https://docs.flutter.io/flutter/widgets/Navigator-class.html
      _kRoutes[item.routeName] = (BuildContext context) {
        return item.buildRoute;
      };
    }
    return new MaterialApp(
      title: 'Flutter Gallery',
      color: Colors.grey,
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme)
          .copyWith(platform: _platform ?? defaultTargetPlatform),
      showPerformanceOverlay: _showPerformanceOverlay,
      checkerboardRasterCacheImages: _checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: _checkerboardOffscreenLayers,
      routes: _kRoutes,
      home: _applyScaleFactor(home),
      navigatorObservers: [new KgNavigatorObserver()],
      builder: (BuildContext context, Widget child) {
        return new Directionality(
          textDirection: _overrideDirection,
          child: _applyScaleFactor(child),
        );
      },
    );
  }
}

class KgNavigatorObserver extends NavigatorObserver {
  /// The [Navigator] pushed `route`.
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didPush$route');
  }

  /// The [Navigator] popped `route`.
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didPop$route');
  }

  /// The [Navigator] removed `route`.
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didRemove$route');
  }

  /// The [Navigator]'s routes are being moved by a user gesture.
  ///
  /// For example, this is called when an iOS back gesture starts, and is used
  /// to disabled hero animations during such interactions.
  void didStartUserGesture() {}

  /// User gesture is no longer controlling the [Navigator].
  ///
  /// Paired with an earlier call to [didStartUserGesture].
  void didStopUserGesture() {}
}
