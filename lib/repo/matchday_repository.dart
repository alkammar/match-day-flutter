import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:match_day/firestore/security_wrapper.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/model/owner.dart';

// const _id = 'Q1TV5heuB4RmeIxv96Qww5Ebo1n2';
// const _id = 'HyW2LUHWggN6oCQlBJA7ZC3X9vy2';

class MatchDayRepository {
  Stream<List<MatchDay>> get stream {
    return FirestoreStream(FirebaseFirestore.instance
        .collection('match_day')
        .where('roles.${FirebaseAuth.instance.currentUser.uid}',
            isLessThanOrEqualTo: 2)
        .snapshots()
        .map<List<MatchDay>>(
      (event) {
        List<MatchDay> list = [];
        event.docs.forEach((element) {
          Owner owner = Owner();
          owner.name = element.data()['owner'];

          var matchDay = MatchDay(
            id: element.id,
            name: element.data()['name'],
            owner: owner,
          );
          list.add(matchDay);
        });
        return list;
      },
    )).stream;
  }

  // Future<List<MatchDay>> fetchUserId() async {
  //   return FirebaseFirestore.instance.collection('profiles')
  // }

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
    return FirebaseFirestore.instance.collection('match_day').add({
      'name': matchDay.name,
      'roles': {FirebaseAuth.instance.currentUser.uid: 1},
      'owner': await _profile,
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
    var owner = Owner();
    owner.name = 'Me';

    return Future.delayed(Duration(seconds: 2), () {
      return matchDay.copyWith(owner: owner);
    });
  }

  Future<void> updateMatchDay(MatchDay matchDay) {
    print('updated match day ${matchDay.id}');
    return FirebaseFirestore.instance
        .collection('match_day')
        .doc(matchDay.id)
        .update(
      {'name': matchDay.name},
    ).then((value) => null);
  }
}
