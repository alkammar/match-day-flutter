import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final bool me;
  final bool owner;

  Player({this.id, this.name, this.me, this.owner});

  Player copyWith({
    String id,
    String name,
    bool me,
    bool owner,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      me: me ?? this.me,
      owner: owner ?? this.owner,
    );
  }

  @override
  List<Object> get props => [id, name, me, owner];
}
