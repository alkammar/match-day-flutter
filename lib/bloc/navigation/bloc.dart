// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:match_day/model/match_day.dart';
// import 'package:match_day/repo/matchday_repository.dart';
//
// // part 'event.dart';
//
// class CreateMatchDayBloc extends Bloc<NavigatorAction, dynamic> {
//   final GlobalKey<NavigatorState> navigatorKey;
//
//   CreateMatchDayBloc({this.navigatorKey}) : super(const NavigatorState());
//
//   @override
//   Stream<dynamic> mapEventToState(NavigatorAction event) async* {
//     if (event is NavigatorActionPop) {
//       navigatorKey.currentState.pop();
//     } else if (event is NavigateToHomeEvent) {
//       navigatorKey.currentState.pushNamed('/home');
//     }
//   }
//
//   @override
//   Future<void> close() {
//     return super.close();
//   }
// }
