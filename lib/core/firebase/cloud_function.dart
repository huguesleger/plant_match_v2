import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

class CloudFunction {
  static const String region = 'europe-west1';

  static TaskEither<Failure, Map<String, dynamic>> call(
    String name,
    Map<String, dynamic> data,
  ) =>
      TaskEither.tryCatch(
        () async => Map<String, dynamic>.from(
          (await FirebaseFunctions.instanceFor(region: region)
                  .httpsCallable(name)
                  .call(data))
              .data as Map,
        ),
        (error, _) => switch (error) {
          FirebaseFunctionsException(:final message) => ValidationFailure(
              Option.fromNullable(message).getOrElse(() => 'Erreur serveur'),
            ),
          _ => UnexpectedFailure('Erreur serveur: $error'),
        },
      );
}
