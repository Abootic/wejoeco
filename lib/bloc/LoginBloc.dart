import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/LoginDto.dart';
import '../repositories/LoginRepository.dart';
import '../repositories/SharedRepository.dart';
import '../utilities/state_types.dart';
import 'package:get_it/get_it.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();

  LoginBloc({required this.repository}) : super(LoginState()) {
    print("LoginBloc initialized with hashCode: ${this.hashCode}");
    on<SubmitData>(_onSubmit);
    on<LogoutEvent>(_onLogout);
    on<CheckLoginStatusEvent>(_onCheckLoginStatus); // New event handler
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

  Future<void> _onLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    print("Handling LogoutEvent in LoginBloc: ${this.hashCode}");
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));

    try {
      await _sharedRepository.clearData();
      print("SharedPreferences cleared successfully");
      emit(LoginState(
        currentState: StateTypes.init,
      ));
      print("Logout state emitted: currentState = init, authResponse = null");
    } catch (e) {
      print("Error during logout: ${e.toString()}");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  // Handle checking login status on app start
  Future<void> _onCheckLoginStatus(CheckLoginStatusEvent event, Emitter<LoginState> emit) async {
    print("Checking login status in LoginBloc: ${this.hashCode}");
    emit(state.copyWith(currentState: StateTypes.submitting));

    try {
      final token = await _sharedRepository.getData("accessToken");
      if (token != null && token.isNotEmpty && token != "error") {
        // Assuming AuthResponse can be reconstructed from stored data
        final userId = await _sharedRepository.getData("userId");
        final userType = await _sharedRepository.getData("userType");
        final username = await _sharedRepository.getData("username"); // Add this if stored

        if (userId != null && userType != null) {
          final authResponse = AuthResponse.fromJson({
            "access_token": token,
            "refresh_token": "", // You might need to store this too if required
            "user": {
              "id": int.parse(userId),
              "userType": userType,
              "username": username ?? "unknown",
            },
          });
          emit(state.copyWith(
            currentState: StateTypes.submitted,
            authResponse: authResponse,
          ));
          print("Login status restored: authResponse = $authResponse");
        } else {
          emit(state.copyWith(currentState: StateTypes.init));
          print("No valid user data found, resetting to init");
        }
      } else {
        emit(state.copyWith(currentState: StateTypes.init));
        print("No valid token found, resetting to init");
      }
    } catch (e) {
      print("Error checking login status: $e");
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

class LogoutEvent extends LoginEvent {}

class CheckLoginStatusEvent extends LoginEvent {} // New event