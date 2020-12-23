// Import the test package and Counter class
import 'package:match_day/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.allMatchDays.listen((event) {
      print(event.name);
    });

    counter.fetchAllMatchDays();

    // expect(counter.value, 1);
  });
}
