part of 'bloc.dart';

abstract class CreateMatchDayEvent extends Equatable {
  const CreateMatchDayEvent();

  @override
  List<Object> get props => [];
}

class CreateMatchDay extends CreateMatchDayEvent {}
