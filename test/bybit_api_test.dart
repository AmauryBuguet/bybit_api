import 'package:bybit_api/bybit_api.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = BybitApi();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.endpoint, isNotEmpty);
    });
  });
}
