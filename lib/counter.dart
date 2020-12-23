import 'package:flutter/foundation.dart';
import 'package:match_day/model/match_day.dart';
import 'package:rxdart/rxdart.dart';

class Counter {
  final _matchDaysFetcher = ReplaySubject<MatchDay>();

  Observable<MatchDay> get allMatchDays => _matchDaysFetcher.stream;

  fetchAllMatchDays() async {
    List<MatchDay> list = [];

    var matchDay1 = MatchDay();
    matchDay1.name = 'First match';
    list.add(matchDay1);

    var matchDay2 = MatchDay();
    matchDay2.name = 'Second match';
    list.add(matchDay2);

    for (var matchDay in list) {
      _matchDaysFetcher.sink.add(matchDay);
    }
  }

  dispose() {
    _matchDaysFetcher.close();
  }
}
