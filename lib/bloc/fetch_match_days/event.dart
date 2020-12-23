part of 'bloc.dart';

abstract class MatchDaysEvent extends Equatable {
  const MatchDaysEvent();

  @override
  List<Object> get props => [];
}

class FetchMatchDays extends MatchDaysEvent {}
