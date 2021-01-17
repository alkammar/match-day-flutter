import 'dart:async';

class FirestoreStream<T> extends Stream<T> {
  final Stream<T> stream;

  FirestoreStream(Stream<T> stream)
      : this.stream = stream.handleError((error) async {
          print('error from FirestoreStream $error');
        });

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
