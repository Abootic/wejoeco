import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/LoginDto.dart';
import '../repositories/LoginRepository.dart';
import '../repositories/SharedRepository.dart';
import '../utilities/state_types.dart';
import 'package:get_it/get_it.dart';

// Define StateTypes for LoginState
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;
 // final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();

  LoginBloc({required this.repository}) : super(LoginState()) {
    on<SubmitData>(_onSubmit);
  }

  // Handle the submit event (for login)
  Future<void> _onSubmit(SubmitData event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));
print("username is ${event.model.values}");
    try {
      final response = await repository.login(event.model);

    /*  if (response.user != null) {
        _sharedRepository.setData("userType", response.user?.userType ?? "UNKNOWN");
        _sharedRepository.setData("userid", response.user?.id?.toString() ?? "0");
      } else {
        throw Exception("User data is missing in login response");
      }
*/
      emit(state.copyWith(
        currentState: StateTypes.submitted,
        error: null,
        authResponse: response,
      ));
    } catch (e) {
      print("============ EXP in submit: ${e.toString()} ========");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }

  }
}

class LoginState {
  final StateTypes currentState;
  final String? error;
  final AuthResponse? authResponse;

  LoginState({
    this.currentState = StateTypes.init,
    this.error,
    this.authResponse,
  });

  LoginState copyWith({
    StateTypes? currentState,
    String? error,
    AuthResponse? authResponse,
  }) {
    return LoginState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      authResponse: authResponse ?? this.authResponse,
    );
  }
}

abstract class LoginEvent {}

class SubmitData extends LoginEvent {
  final Map<String, dynamic> model;

  SubmitData({required this.model});
}
