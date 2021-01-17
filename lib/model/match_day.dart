import 'package:equatable/equatable.dart';
import 'package:match_day/model/owner.dart';

class MatchDay extends Equatable {
  final String id;
  final String name;
  final Owner owner;
  final String location;
  final bool invitation;

  MatchDay({
    this.id,
    this.name,
    this.owner,
    this.location,
    this.invitation = false,
  });

  @override
  List<Object> get props => [id, name, owner, location, invitation];

  MatchDay copyWith({
    String id,
    String name,
    Owner owner,
    String location,
    bool invitation,
  }) {
    MatchDay matchDay = MatchDay(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      location: location ?? this.location,
      invitation: invitation ?? this.invitation,
    );

    return matchDay;
  }
}
