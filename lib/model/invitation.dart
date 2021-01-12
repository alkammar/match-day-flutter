import 'package:match_day/model/match_day.dart';

class Invitation extends MatchDay {
  Invitation({
    String id,
    String name,
  }) : super(
          invitation: true,
          id: id,
          name: name,
        );
}
