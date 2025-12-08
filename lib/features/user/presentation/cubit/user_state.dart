import 'package:plant_match_v2/features/user/domain/entities/user.dart';

sealed class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User data;

  UserLoaded({required this.data});
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
