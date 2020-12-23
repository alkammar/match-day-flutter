import 'dart:async';

import 'package:match_day/model/admin.dart';
import 'package:match_day/model/match_day.dart';

class MatchDayRepository {
  // final moviesApiProvider = MovieApiProvider();

  // Future<Matchday> fetchAllMovies() => moviesApiProvider.fetchMovieList();
  List<MatchDay> list = [];

  Future<List<MatchDay>> fetchMatchDays() async {

    if (list.isEmpty) {
      User admin = User();
      admin.name = 'HDMI';

      var matchDay1 = MatchDay();
      matchDay1.name = 'First match';
      matchDay1.admin = admin;
      list.add(matchDay1);

      var matchDay2 = MatchDay();
      matchDay2.name = 'Second match';
      matchDay2.admin = admin;
      list.add(matchDay2);
    }

    return Future.delayed(Duration(seconds: 1), () => list);
    // return Future.error('my error');
  }

  StreamController<MatchDay> controller = StreamController<MatchDay>();

  StreamSubscription<MatchDay> listenToUpdates(Function f) {
    return controller.stream.listen((value) {
      f.call(value);
    });
  }

  Future<MatchDay> createMatchDay() async {
    var matchDay = MatchDay();
    matchDay.name = 'Anonymous match';

    var admin = User();
    admin.name = 'Me';

    matchDay.admin = admin;

    return Future.delayed(Duration(seconds: 1), () => matchDay);
  }

  Future<MatchDay> assignAdmin(MatchDay matchDay) {
    var admin = User();
    admin.name = 'Me';

    return Future.delayed(Duration(seconds: 2), () {
      matchDay.admin = admin;
      return matchDay;
    });
  }

  Future<String> updateName(MatchDay matchDay, String name) {
    matchDay.name = name;
    return Future.delayed(Duration(seconds: 0), () => name);
  }

  Future<MatchDay> update(MatchDay matchDay, MatchDay editedMatchDay) {
    return Future.delayed(Duration(seconds: 3), () {

      matchDay.name = editedMatchDay.name;
      matchDay.admin = editedMatchDay.admin;

      if (!list.contains(matchDay)) {
        list.add(matchDay);
      }
      controller.add(matchDay);
      return matchDay;
    });
  }
}