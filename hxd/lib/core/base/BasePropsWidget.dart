import 'package:flutter/material.dart';

abstract class BasePropsWidget extends StatefulWidget {
  BasePropsWidget(this.props, {Key key}) : super(key: key);

  final Map<String, dynamic> props;
}
