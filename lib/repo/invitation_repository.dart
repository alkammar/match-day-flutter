import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<String> createInvitation(MatchDay matchDay) {
    return FirebaseFirestore.instance
        .collection('match_days')
        .doc(matchDay.id)
        .collection('invitations')
        .add({}).then((doc) {
      return doc.id;
    });
  }

  Future<Invitation> addJoinRequest(Invitation invitation) {
    return FirebaseFirestore.instance
        .collection('match_days')
        .doc(invitation.matchDay.id)
        .collection('invitations')
        .doc(invitation.id)
        .collection('join_requests')
        .add({
      // TODO add user id
    }).then((value) {
      return value.get().then((snapshot) {
        return invitation;
      });
    });
  }

  StreamController<MatchDay> controller = StreamController<MatchDay>();

  StreamSubscription<MatchDay> listenToUpdates(Function f) {
    return controller.stream.listen((value) {
      f.call(value);
    });
  }
}
