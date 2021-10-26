import 'package:rxdart/rxdart.dart';

class Counter {
  final BehaviorSubject<int> _counter = BehaviorSubject.seeded(0);

  get stream$ => _counter.stream;
  get current => _counter.value;

  void increment() {
    _counter.add(_counter.value + 1);
    print('incremented !!!');
  }

  void setCounter(int val) {
    _counter.add(val);
    print('setCounter');
  }
}
