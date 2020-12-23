import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/create_match_day/bloc.dart';
import 'package:match_day/bloc/edit_match_day/bloc.dart';
import 'package:match_day/bloc/fetch_match_days/bloc.dart';
import 'package:match_day/repo/matchday_repository.dart';
import 'package:match_day/ui/create_match_day_page.dart';
import 'package:match_day/ui/home_page.dart';

void main() {
  EquatableConfig.stringify = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final matchDayRepository = MatchDayRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/create') {
          return MaterialPageRoute(builder: (context) {
            // ignore: close_sinks
            var editMatchDayBloc = EditMatchDayBloc(
              matchDay: settings.arguments,
              matchDayRepository: matchDayRepository,
            );

            // ignore: close_sinks
            var createMatchDayBloc = CreateMatchDayBloc(
              matchDayRepository: matchDayRepository,
              editMatchDayBloc: editMatchDayBloc,
            );

            return MultiBlocProvider(
              providers: [
                BlocProvider<CreateMatchDayBloc>(create: (context) => createMatchDayBloc),
                BlocProvider<EditMatchDayBloc>(create: (context) => editMatchDayBloc),
              ],
              child: CreateMatchDayPage(),
            );
          });
        } else if (settings.name == '/details') {
          return MaterialPageRoute(builder: (context) {
            // ignore: close_sinks
            var editMatchDayBloc = EditMatchDayBloc(
              matchDay: settings.arguments,
              matchDayRepository: matchDayRepository,
            );

            return MultiBlocProvider(
              providers: [
                BlocProvider<EditMatchDayBloc>(create: (context) => editMatchDayBloc),
              ],
              child: CreateMatchDayPage(matchDay: settings.arguments),
            );
          });
        } else {
          return MaterialPageRoute(builder: (context) => null);
        }
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FetchMatchDaysBloc>(
              create: (context) {
                return FetchMatchDaysBloc(matchDayRepository: matchDayRepository);
              }),
        ],
        child: HomePage(),
      ),
    );
  }
}
