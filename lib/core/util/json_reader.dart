import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

extension JsonReader on Map<String, dynamic> {
  Option<T> read<T>(String key) {
    final value = this[key];
    return value is T ? Some(value) : const None();
  }

  String string(String key, [String fallback = '']) =>
      read<String>(key).getOrElse(() => fallback);

  Option<String> nonEmptyString(String key) =>
      read<String>(key).filter((value) => value.trim().isNotEmpty);

  int integer(String key, [int fallback = 0]) =>
      read<num>(key).map((value) => value.toInt()).getOrElse(() => fallback);

  Option<double> decimal(String key) =>
      read<num>(key).map((value) => value.toDouble());

  bool boolean(String key, [bool fallback = false]) =>
      read<bool>(key).getOrElse(() => fallback);

  List<T> listOf<T>(String key) => read<List<dynamic>>(key)
      .map((values) => values.whereType<T>().toList())
      .getOrElse(() => <T>[]);

  Map<String, dynamic> object(String key) => read<Map<dynamic, dynamic>>(key)
      .map((value) => value.map((k, v) => MapEntry(k.toString(), v)))
      .getOrElse(() => <String, dynamic>{});

  Option<DateTime> date(String key) =>
      Option<Object>.fromNullable(this[key]).flatMap(
        (value) => switch (value) {
          Timestamp() => Some(value.toDate()),
          DateTime() => Some(value),
          String() => Option.fromNullable(DateTime.tryParse(value)),
          Object() => const None(),
        },
      );
}
