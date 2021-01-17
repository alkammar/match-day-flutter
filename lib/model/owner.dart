import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  String name;

  @override
  List<Object> get props => [name];
}
