part of 'bloc.dart';

abstract class MatchDayAdminEvent extends Equatable {
  const MatchDayAdminEvent();

  @override
  List<Object> get props => [];
}

class Assigning extends MatchDayAdminEvent {}

class Ready extends MatchDayAdminEvent {
  final admin;

  Ready(this.admin);
}
