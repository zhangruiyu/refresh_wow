import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({Key key, this.title, this.onPress}) : super(key: key);

  final String title;
  final VoidCallback onPress;

  @override
  State<StatefulWidget> createState() {
    return new SubmitButtonState(title: title, onPress: onPress);
  }
}

class SubmitButtonState extends State<SubmitButton> {
  SubmitButtonState({this.title, this.onPress});

  String title;
  VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    var accentBorderColor = Theme.of(context).accentColor;
    return new Container(
      child: new FlatButton(
        child: new Text(title),
        onPressed: onPress,
      ),
      width: 200.0,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(18.0),
        border: new Border.all(
          color: accentBorderColor,
          width: 2.0,
        ),
      ),
    );
  }
}
