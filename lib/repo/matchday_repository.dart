import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_day/model/admin.dart';
import 'package:match_day/model/match_day.dart';

class MatchDayRepository {
  List<MatchDay> list = [];

  Stream<List<MatchDay>> _onlineStream = FirebaseFirestore.instance
      .collection('match_days')
      .snapshots()
      .map<List<MatchDay>>(
    (event) {
      List<MatchDay> list = [];
      event.docs.forEach((element) {
        print('event from firestore ${element.data()['name']}');

        User admin = User();
        admin.name = 'HDMI';

        var matchDay = MatchDay(
          id: element.id,
          name: element.data()['name'],
          admin: admin,
        );
        list.add(matchDay);
      });
      return list;
    },
  );

  Stream<List<MatchDay>> get stream {
    return _onlineStream;
  }

  Future<List<MatchDay>> fetchMatchDays() async {
    return _onlineStream.first;
  }

  Future<MatchDay> createMatchDay() async {
    return FirebaseFirestore.instance
        .collection('match_days')
        .add({}).then((value) {
      return value.get().then((snapshot) {
        var admin = User();
        admin.name = 'Me';

        return MatchDay(
          id: snapshot.id,
          name: snapshot.data()['name'] ?? '',
          admin: admin,
        );
      });
    });
  }

  Future<MatchDay> assignAdmin(MatchDay matchDay) {
    var admin = User();
    admin.name = 'Me';

    return Future.delayed(Duration(seconds: 2), () {
      return matchDay.copyWith(admin: admin);
    });
  }

  Future<void> update(MatchDay matchDay) {
    print('updated match day ${matchDay.id}');
    return FirebaseFirestore.instance
        .collection('match_days')
        .doc(matchDay.id)
        .update(
      {'name': matchDay.name},
    ).then((value) => null);
  }
}
