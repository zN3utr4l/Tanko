import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/core/result.dart';

void main() {
  test('Ok carries a value, Err carries a failure', () {
    const Result<int> ok = Ok(42);
    const Result<int> err = Err(Failure('boom'));

    expect(switch (ok) {
      Ok(:final value) => value,
      Err() => -1,
    }, 42);
    expect(switch (err) {
      Ok() => '',
      Err(:final failure) => failure.message,
    }, 'boom');
  });
}
