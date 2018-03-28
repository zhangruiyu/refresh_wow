import 'package:flutter/material.dart';

abstract class BasePageRoute extends StatefulWidget {
  BasePageRoute(this.props, {Key key}) : super(key: key);

  final Map<String, dynamic> props;
}

abstract class BasePageLessRoute extends StatelessWidget {
  BasePageLessRoute(this.props);

  final Map<String, dynamic> props;
}
