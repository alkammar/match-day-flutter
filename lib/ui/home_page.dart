import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/fetch_match_days/bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/ui/match_day_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    BlocProvider.of<FetchMatchDaysBloc>(context).add(FetchMatchDays());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Day"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() => BlocProvider.of<FetchMatchDaysBloc>(context).add(FetchMatchDays()));
        },
        child: BlocBuilder<FetchMatchDaysBloc, MatchDaysState>(
          builder: (context, state) {
            debugPrint('state ${state.toString()}');
            if (state.error.isNotEmpty) {
              return Center(child: Text(state.error));
            } else if (state.started) {
              return Center(child: CircularProgressIndicator());
            } else if (state.matchDays == null) {
              return Center(child: Text("Start by creating a Match day!"));
            } else {
              return ListView.builder(
                itemCount: state.matchDays.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: MatchDayItemWidget(matchDay: state.matchDays[index]),
                  );
                },
              );
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
