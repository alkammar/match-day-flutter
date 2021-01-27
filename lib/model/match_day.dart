import 'package:equatable/equatable.dart';
import 'package:match_day/model/join_request.dart';
import 'package:match_day/model/player.dart';

class MatchDay extends Equatable {
  final String id;
  final String name;
  // final Player owner;
  // final Player me;
  final String location;
  final bool invitation;
  final List<JoinRequest> joinRequests;
  final List<Player> players;

  MatchDay({
    this.id,
    this.name,
    // this.owner,
    // this.me,
    this.location,
    this.invitation = false,
    this.joinRequests,
    this.players,
  });

  @override
  List<Object> get props =>
      [id, name, location, invitation, joinRequests, players];

  MatchDay copyWith({
    String id,
    String name,
    // Player owner,
    // Player me,
    String location,
    bool invitation,
    List<JoinRequest> joinRequests,
    List<Player> players,
  }) {
    MatchDay matchDay = MatchDay(
      id: id ?? this.id,
      name: name ?? this.name,
      // owner: owner ?? this.owner,
      // me: me ?? this.me,
      location: location ?? this.location,
      invitation: invitation ?? this.invitation,
      joinRequests: joinRequests ?? this.joinRequests,
      players: players ?? this.players,
    );

    return matchDay;
  }

  Player get owner {
    for (var p in players) {
      if (p.owner) {
        return p;
      }
    }

    return null;
  }

  bool get mine {
    return owner?.me;
  }
}
