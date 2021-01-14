part of 'bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class Init extends EditProfileEvent {}

class EditName extends EditProfileEvent {
  final String name;

  EditName(this.name);
}

class SubmitEdits extends EditProfileEvent {}
