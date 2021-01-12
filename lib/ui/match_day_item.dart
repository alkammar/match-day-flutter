import 'package:flutter/widgets.dart';
import 'package:match_day/model/match_day.dart';

class MatchDayItemWidget extends StatelessWidget {
  final MatchDay matchDay;

  const MatchDayItemWidget({
    Key key,
    this.matchDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!matchDay.invitation) {
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
    } else {
      return Text('${matchDay?.name}');
    }
  }
}
