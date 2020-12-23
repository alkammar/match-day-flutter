
import 'package:equatable/equatable.dart';

class User extends Equatable {

  String name;

  @override
  List<Object> get props => [name];
}