part of 'bloc.dart';

abstract class EditMatchDayEvent extends Equatable {
  const EditMatchDayEvent();

  @override
  List<Object> get props => [];
}

class EditName extends EditMatchDayEvent {
  final String name;

  EditName(this.name);
}

class EditLocation extends EditMatchDayEvent {
  final String location;

  EditLocation(this.location);
}

class SubmitEdits extends EditMatchDayEvent {}
