part of 'bloc.dart';

abstract class DynamicLinkEvent extends Equatable {
  const DynamicLinkEvent();

  @override
  List<Object> get props => [];
}

class Init extends DynamicLinkEvent {}

class DynamicLinkReceived extends DynamicLinkEvent {
  final link;
  const DynamicLinkReceived(this.link);

  @override
  List<Object> get props => [link];
}
