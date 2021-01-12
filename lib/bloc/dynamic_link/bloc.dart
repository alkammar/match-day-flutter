import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  DynamicLinkBloc() : super(const DynamicLinkState()) {
    add(Init());
  }

  @override
  Stream<DynamicLinkState> mapEventToState(DynamicLinkEvent event) async* {
    if (event is Init) {
      yield* _init(event);
    } else if (event is DynamicLinkReceived) {
      yield state.copyWith(link: event.link);
    }
  }

  Stream<DynamicLinkState> _init(Init event) async* {
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        add(DynamicLinkReceived(deepLink));
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      add(DynamicLinkReceived(deepLink));
    }
  }
}
