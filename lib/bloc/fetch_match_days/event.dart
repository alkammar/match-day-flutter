part of 'bloc.dart';

abstract class MatchDaysEvent extends Equatable {
  const MatchDaysEvent();

  @override
  List<Object> get props => [];
}

class MatchDaysRequested extends MatchDaysEvent {}

class MatchDaysUpdated extends MatchDaysEvent {
  final matchDays;

  MatchDaysUpdated(this.matchDays);
}
