import 'package:flutter/widgets.dart';

class MatchDayItemWidget extends StatelessWidget {
  final matchDay;

  const MatchDayItemWidget({
    Key key,
    this.matchDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text('${matchDay?.name}'),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: matchDay,
        );
      },
    );
  }
}
