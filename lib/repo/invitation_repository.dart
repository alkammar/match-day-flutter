import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:match_day/model/invitation.dart';
import 'package:match_day/model/match_day.dart';

class InvitationRepository {
  List<Invitation> list = [];

  Future<List<Invitation>> fetchInvitations() async {
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
        .add({
      'expiresIn': 30,
    }).then((doc) {
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
      'mdid': invitation.matchDay.id,
      'iid': invitation.id,
      'pid': FirebaseAuth.instance.currentUser.uid,
      'name': FirebaseAuth.instance.currentUser.displayName
    }).then((value) {
      return value.get().then((snapshot) {
        return invitation;
      });
    });
  }
}
