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
    on<SubmitData>(_onSubmit);
    on<LogoutEvent>(_onLogout);
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
  }

  Future<void> _onSubmit(SubmitData event, Emitter<LoginState> emit) async {
    emit(state.copyWith(currentState: StateTypes.submitting, error: null));

    try {
      final response = await repository.login(event.model);

      if (response.user != null) {
        final user = response.user!;

        await _sharedRepository.setData("accessToken", response.accessToken);
        await _sharedRepository.setData("userId", user.id.toString());
        await _sharedRepository.setData("userType", user.userType ?? "");
        await _sharedRepository.setData("username", user.username ?? "");

        emit(state.copyWith(
          currentState: StateTypes.submitted,
          error: null,
          authResponse: response,
        ));
      } else {
        throw Exception("User is null in the login response");
      }
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(currentState: StateTypes.submitting, error: null));
    try {
      await _sharedRepository.clearData();
      emit(LoginState());
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCheckLoginStatus(CheckLoginStatusEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(currentState: StateTypes.submitting));
    try {
      final token = await _sharedRepository.getData("accessToken");
      final userId = await _sharedRepository.getData("userId");
      final userType = await _sharedRepository.getData("userType");
      final username = await _sharedRepository.getData("username");

      print("Token: $token, UserId: $userId, UserType: $userType, Username: $username"); // Debug log

      if (token != null && token.isNotEmpty &&
          userId != null && userId.isNotEmpty &&
          userType != null && userType.isNotEmpty &&
          username != null && username.isNotEmpty) {
        final authResponse = AuthResponse.fromJson({
          "succeeded": true,
          "access_token": token,
          "refresh_token": "",
          "user": {
            "id": int.parse(userId),
            "userType": userType,
            "username": username,
          },
        });
        emit(state.copyWith(
          currentState: StateTypes.submitted,
          authResponse: authResponse,
        ));
      } else {
        await _sharedRepository.clearData();
        emit(LoginState());
      }
    } catch (e) {
      await _sharedRepository.clearData();
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

class CheckLoginStatusEvent extends LoginEvent {}
