import 'package:equatable/equatable.dart';
import 'package:match_day/model/match_day.dart';

class Invitation extends Equatable {
  final String id;
  final MatchDay matchDay;

  Invitation({
    this.id,
    this.matchDay,
  });

  @override
  List<Object> get props => [id, matchDay];
}
