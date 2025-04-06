import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/CustomerDTO.dart';
import '../repositories/CustomerRepository.dart';
import '../utilities/state_types.dart';

class CustomersBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;

  CustomersBloc({required this.repository}) : super(CustomerState()) {
    on<SubmitData>(_onSubmit);
    on<LoadData>(_onLoadData);
    on<LoadDataById>(_onLoadDataById);
  }

  Future<void> _onSubmit(SubmitData event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(currentState: StateTypes.submitting, error: null));
    try {
      final response = await repository.add(event.model);
      emit(state.copyWith(
        currentState: StateTypes.submitted,
        error: null,
        postdata: response,
      ));
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }

  Future<void> _onLoadData(LoadData event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading, error: null));
    try {
      final items = await repository.getAll(refresh: event.forceRefresh);
      emit(state.copyWith(
        currentState: StateTypes.loaded,
        error: null,
        data: items,
      ));
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }

  Future<void> _onLoadDataById(LoadDataById event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading, error: null));
    try {
      final res = await repository.getById(event.Id);
      if (res != null) {
        emit(state.copyWith(
          currentState: StateTypes.loaded,
          error: null,
          postdata: res,
        ));
      } else {
        emit(state.copyWith(currentState: StateTypes.error, error: 'Customer not found'));
      }
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }
}

class CustomerState {
  final StateTypes currentState;
  final String? error;
  final List<CustomerDTO>? data;
  final CustomerDTO? postdata;

  CustomerState({
    this.currentState = StateTypes.init,
    this.error,
    this.data,
    this.postdata,
  });

  CustomerState copyWith({
    StateTypes? currentState,
    String? error,
    List<CustomerDTO>? data,
    CustomerDTO? postdata,
    bool clearData = false,
  }) {
    return CustomerState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      data: clearData ? null : (data ?? this.data),
      postdata: postdata ?? this.postdata,
    );
  }
}

abstract class CustomerEvent {}

class SubmitData extends CustomerEvent {
  final Map<String, dynamic> model;
  SubmitData({required this.model});
}

class LoadData extends CustomerEvent {
  final bool forceRefresh;
  LoadData({this.forceRefresh = false});
}

class LoadDataById extends CustomerEvent {
  final int Id;
  LoadDataById({required this.Id});
}