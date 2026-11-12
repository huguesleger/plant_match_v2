import 'package:fpdart/fpdart.dart';

extension TaskEitherMinimalDelay<L, R> on TaskEither<L, R> {
  TaskEither<L, R> withMinimalDelay(Duration duration) => TaskEither(() {
        final delay = Future<void>.delayed(duration);
        return run().then((result) => delay.then((_) => result));
      });

  TaskEither<L, R> withMinimalDelayOnRight(Duration duration) =>
      TaskEither(() {
        final delay = Future<void>.delayed(duration);
        return run().then(
          (result) =>
              result.isRight() ? delay.then((_) => result) : Future.value(result),
        );
      });
}
