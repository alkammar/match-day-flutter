import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:match_day/firestore/security_wrapper.dart';
import 'package:match_day/model/invitation.dart';
import 'package:match_day/model/join_request.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/model/player.dart';
import 'package:match_day/model/profile.dart';

class MatchDayRepository {
  Stream<List<MatchDay>> get stream {
    return FirestoreStream(FirebaseFirestore.instance
        .collection('match_days')
        .where('roles.${FirebaseAuth.instance.currentUser.uid}.type',
            isLessThanOrEqualTo: 2)
        .snapshots()
        .map<List<MatchDay>>(
      (event) {
        List<MatchDay> list = [];
        event.docs.forEach((element) {
          Map roles = element.data()['roles'];

          List<Player> players = [];
          roles.forEach((key, value) {
            var player = Player(
              id: key,
              name: value['name'],
              me: key == FirebaseAuth.instance.currentUser.uid,
              owner: value['type'] == 1,
            );

            players.add(player);
          });

          var matchDay = MatchDay(
              id: element.id, name: element.data()['name'], players: players);
          list.add(matchDay);
        });
        return list;
      },
    )).stream;
  }

  Future<List<MatchDay>> fetchMatchDays() async {
    return FirestoreStream(stream).stream.first;

    // return stream.timeout(
    //   Duration(seconds: 4),
    //   onTimeout: (EventSink<List<MatchDay>> sink) {
    //     sink.addError('event from firestore timed out');
    //   },
    // ).first;
  }

  Future<MatchDay> createMatchDay(MatchDay matchDay) async {
    return FirebaseFirestore.instance.collection('match_days').add({
      'name': matchDay.name,
      'roles': {
        FirebaseAuth.instance.currentUser.uid: {
          'type': 1,
          'name': await _profile
        }
      },
    }).then((value) async => matchDay.copyWith(id: value.id));
  }

  Future<String> get _profile {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) => value.data()['name']);
  }

  Future<MatchDay> assignAdmin(MatchDay matchDay) {
    var owner = Player(name: 'Me');

    return Future.delayed(Duration(seconds: 2), () {
      return matchDay.copyWith();
    });
  }

  Future<void> updateMatchDay(MatchDay matchDay) {
    return FirebaseFirestore.instance
        .collection('match_days')
        .doc(matchDay.id)
        .update(
      {'name': matchDay.name},
    );
  }

  Future<List<JoinRequest>> fetchJoinRequests(MatchDay matchDay) {
    return FirebaseFirestore.instance
        .collectionGroup('join_requests')
        .where('mdid', isEqualTo: matchDay.id)
        .get()
        .then((QuerySnapshot value) {
      List<JoinRequest> joinRequests = [];

      value.docs.forEach((element) {
        joinRequests.add(JoinRequest(
            id: element.id,
            invitation:
                Invitation(id: element.data()['iid'], matchDay: matchDay),
            profile: Profile(
              id: element.data()['pid'],
              name: element.data()['name'],
            )));
      });

      return joinRequests;
    });
  }

  Future<void> acceptJoinRequest(MatchDay matchDay, JoinRequest joinRequest) {
    return FirebaseFirestore.instance
        .collection('match_days')
        .doc(matchDay.id)
        .collection('invitations')
        .doc(joinRequest.invitation.id)
        .collection('join_requests')
        .doc(joinRequest.id)
        // TODO this deletion is a server action
        .delete()
        .then((value) {
      return FirebaseFirestore.instance
          .collection('match_days')
          .doc(matchDay.id)
          .update({
        'roles.${joinRequest.profile.id}': {
          'type': 2,
          'name': joinRequest.profile.name
        }
      });
    });
  }
}
