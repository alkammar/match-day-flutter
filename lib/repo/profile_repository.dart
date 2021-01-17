import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:match_day/model/profile.dart';

class ProfileRepository {
  Profile profile;

  Stream<Profile> get stream => Stream.fromFuture(fetchProfile());

  Future<Profile> fetchProfile() async {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) => Profile(
              id: doc.id,
              name: FirebaseAuth.instance.currentUser.displayName,
              nickName: doc.data()['name'],
            ));
  }

  Future<Profile> createProfile() async {
    profile = Profile(id: '1234567890');

    return Future.delayed(Duration(seconds: 1), () => profile);
  }

  Future<Profile> update(Profile profile) {
    return Future.delayed(Duration(seconds: 3), () {
      this.profile = this.profile.copyWith(
            name: profile.name,
            nickName: profile.nickName,
          );

      return profile;
    });
  }
}
