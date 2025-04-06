import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/SupplierDTO.dart';
import '../repositories/SupplierRepository.dart';
import '../utilities/state_types.dart';

abstract class SupplierEvent {}

class LoadData extends SupplierEvent {
  final bool forceRefresh;
  LoadData({this.forceRefresh = false});
}

class LoadDataById extends SupplierEvent {
  final int Id;
  LoadDataById({required this.Id});
}

class SubmitData extends SupplierEvent {
  final Map<String, dynamic> model;
  SubmitData({required this.model});
}

class SupplierState {
  final StateTypes currentState;
  final String? error;
  final List<SupplierDTO>? data;
  final SupplierDTO? singleData;

  SupplierState({
    required this.currentState,
    this.error,
    this.data,
    this.singleData,
  });

  factory SupplierState.initial() {
    return SupplierState(
      currentState: StateTypes.loading,
      error: null,
      data: null,
      singleData: null,
    );
  }

  SupplierState copyWith({
    StateTypes? currentState,
    String? error,
    List<SupplierDTO>? data,
    SupplierDTO? singleData,
  }) {
    return SupplierState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      data: data ?? this.data,
      singleData: singleData ?? this.singleData,
    );
  }
}



class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository repository;

  SupplierBloc({required this.repository}) : super(SupplierState.initial()) {
    // Register event handlers
    on<LoadData>(_onLoadData);
    on<LoadDataById>(_onLoadDataById);
    on<SubmitData>(_onSubmitData);
  }
  Future<void> _onLoadData(LoadData event, Emitter<SupplierState> emit) async {
    print("Loading suppliers...");
    emit(state.copyWith(currentState: StateTypes.loading, error: null));

    try {
      final items = await repository.getAll(refresh: event.forceRefresh);
      print("Fetched suppliers: ${items.length}");

      if (items.isEmpty) {
        emit(state.copyWith(
          currentState: StateTypes.empty,
          error: null,
          data: items,
        ));
      } else {
        emit(state.copyWith(
          currentState: StateTypes.loaded,
          error: null,
          data: items,
        ));
      }
    } catch (e) {
      print("Error loading suppliers: $e");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadDataById(LoadDataById event, Emitter<SupplierState> emit) async {
    print("Loading supplier by ID: ${event.Id}");
    emit(state.copyWith(currentState: StateTypes.loading, error: null));

    try {
      final item = await repository.getById(event.Id);
      print("Repository returned: $item");

      if (item != null) {
        emit(state.copyWith(
          currentState: StateTypes.loaded,
          error: null,
          singleData: item,
        ));
      } else {
        emit(state.copyWith(
          currentState: StateTypes.error,
          error: 'Supplier not found',
        ));
      }
    } catch (e) {
      print("Error loading supplier by ID: $e");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitData(SubmitData event, Emitter<SupplierState> emit) async {
    print("Submitting data...");
    emit(state.copyWith(currentState: StateTypes.submitting, error: null));

    try {
      final response = await repository.add(event.model);

      if (response != null) {
        emit(state.copyWith(
          currentState: StateTypes.submitted,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          currentState: StateTypes.error,
          error: 'Failed to submit data: No response from the server',
        ));
      }
    } catch (e) {
      print("Error submitting data: $e");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: 'Error submitting data: $e',
      ));
    }
  }
}