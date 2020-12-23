
import 'package:equatable/equatable.dart';
import 'package:match_day/model/admin.dart';

class MatchDay extends Equatable {

  String name;
  User admin;
  String location;

  @override
  List<Object> get props => [name, admin, location];

  MatchDay clone() {
    MatchDay matchDay = MatchDay();
    matchDay.name = name;
    matchDay.admin = admin;
    matchDay.location = location;

    return matchDay;
  }
}