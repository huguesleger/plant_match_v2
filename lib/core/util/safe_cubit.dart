import 'package:flutter_bloc/flutter_bloc.dart';

/// Un Cubit sécurisé qui évite de lever des exceptions lors de l'émission d'états
/// si le Cubit a déjà été fermé (ex: après retour en arrière d'un écran).
abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
