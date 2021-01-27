import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/edit_match_day/bloc.dart';
import 'package:match_day/bloc/invite_players/bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';

class MatchDayDetailsScreen extends StatefulWidget {
  @override
  _MatchDayDetailsScreenState createState() => _MatchDayDetailsScreenState();

  static Route route({@required MatchDay matchDay}) {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<InvitePlayersBloc>(
              create: (context) => InvitePlayersBloc(
                    invitationRepository:
                        RepositoryProvider.of<InvitationRepository>(context),
                  )),
          BlocProvider<EditMatchDayBloc>(
              create: (context) => EditMatchDayBloc(
                    matchDay: matchDay,
                    matchDayRepository:
                        RepositoryProvider.of<MatchDayRepository>(context),
                  )),
        ],
        child: MatchDayDetailsScreen(),
      );
    });
  }
}

class _MatchDayDetailsScreenState extends State<MatchDayDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
      builder: (BuildContext context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(state.original.name),
                background: Image.network(
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                key: Key(state.original.players[index].id),
                padding: const EdgeInsets.all(16.0),
                child: Text(state.original.players[index].name),
              );
            }, childCount: state.original.players.length)),
            // SliverFixedExtentList(delegate: null, itemExtent: null),
          ],
        );
      },
    ), floatingActionButton: BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
      builder: (BuildContext context, state) {
        if (state.original?.mine ?? false) {
          return FloatingActionButton(
            onPressed: () {
              BlocProvider.of<InvitePlayersBloc>(context)
                  .add(SendInvitation(state.original));
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
