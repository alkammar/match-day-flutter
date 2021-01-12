import 'dart:async';

import 'package:match_day/model/invitation.dart';
import 'package:match_day/model/match_day.dart';

class InvitationRepository {
  List<MatchDay> list = [];

  Future<List<MatchDay>> fetchMatchDays() async {
    if (list.isEmpty) {
      // list.add(MatchDay(
      //   name: 'Invitation match',
      //   invitation: true,
      // ));
    }

    return Future.delayed(Duration(seconds: 1), () => list);
  }

  Future<Invitation> addMatchDay(Invitation invitation) {
    return Future.delayed(Duration(seconds: 2), () {
      invitation = invitation.copyWith();
      if (!list.contains(invitation)) {
        list.add(invitation);
      }
      controller.add(invitation);

      return invitation;
    });
  }

  StreamController<MatchDay> controller = StreamController<MatchDay>();

  StreamSubscription<MatchDay> listenToUpdates(Function f) {
    return controller.stream.listen((value) {
      f.call(value);
    });
  }
}
