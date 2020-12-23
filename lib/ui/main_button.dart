import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainButton extends StatelessWidget {
  final loading;
  final onPressed;
  final label;

  const MainButton({
    Key key,
    this.onPressed,
    this.loading,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (this.loading) {
    return AspectRatio(
      aspectRatio: 1,
      child: FractionallySizedBox(
        heightFactor: 0.7,
        widthFactor: 0.7,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).canvasColor),
        ),
      ),
    );
    } else {
      return Text(label);
    }
  }
}
