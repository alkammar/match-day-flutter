import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/authentication/bloc.dart';
import 'package:match_day/bloc/fetch_match_days/bloc.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';
import 'package:match_day/ui/match_day_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  static Route route() {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<FetchMatchDaysBloc>(create: (context) {
            return FetchMatchDaysBloc(
              matchDayRepository:
                  RepositoryProvider.of<MatchDayRepository>(context),
              invitationRepository:
                  RepositoryProvider.of<InvitationRepository>(context),
            );
          }),
        ],
        child: HomeScreen(),
      );
    });
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    BlocProvider.of<FetchMatchDaysBloc>(context).add(MatchDaysRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Day"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() => BlocProvider.of<FetchMatchDaysBloc>(context)
              .add(MatchDaysRequested()));
        },
        child: BlocBuilder<FetchMatchDaysBloc, MatchDaysState>(
          builder: (context, state) {
            debugPrint('state ${state.toString()}');
            if (state.status == MatchDaysStatus.error) {
              return Center(child: Text(state.error));
            } else if (state.status == MatchDaysStatus.fetching) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == MatchDaysStatus.complete) {
              if (state.matchDays == null) {
                return Center(child: Text("Start by creating a Match day!"));
              } else {
                return ListView.builder(
                  itemCount: state.matchDays.length,
                  itemBuilder: (context, index) {
                    var item = state.matchDays[index];
                    return ListTile(
                      key: Key(item.id),
                      title: MatchDayItemWidget(matchDay: item),
                    );
                  },
                );
              }
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/create',
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
