import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';

sealed class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User data;

  const UserLoaded({required this.data});
}

class UserError extends UserState {
  final Failure failure;

  const UserError(this.failure);
}
