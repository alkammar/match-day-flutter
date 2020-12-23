part of 'bloc.dart';

abstract class MatchDayNameEvent extends Equatable {
  const MatchDayNameEvent();

  @override
  List<Object> get props => [];
}

class Loading extends MatchDayNameEvent {}

class Initialized extends MatchDayNameEvent {
  final name;

  Initialized(this.name);
}
