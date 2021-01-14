import 'dart:async';

import 'package:match_day/model/profile.dart';

class ProfileRepository {
  Profile profile;

  Future<Profile> fetchProfile() async {
    return Future.delayed(Duration(seconds: 1), () => profile);
    // return Future.error('my error');
  }

  StreamController<Profile> controller = StreamController<Profile>();

  StreamSubscription<Profile> listenToUpdates(Function f) {
    return controller.stream.listen((value) {
      f.call(value);
    });
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

      controller.add(profile);
      return profile;
    });
  }
}
