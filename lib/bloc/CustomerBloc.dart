import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/CustomerDTO.dart';
import '../models/SupplierDTO.dart';
import '../repositories/CustomerRepository.dart';
import '../utilities/state_types.dart';

// SupplierBloc that handles events and emits states
class CustomersBloc extends Bloc<SupplierEvent, SupplierState> {
  final CustomerRepository repository;

  CustomersBloc({required this.repository}) : super(SupplierState()) {
    on<SubmitData>(_onSubmit);
    on<LoadData>(_onLoadData);
    on<LoadDataById>(_onLoadDataById);
  }

  // Submit supplier data
  Future<void> _onSubmit(SubmitData event, Emitter<SupplierState> emit) async {
    emit(state.copyWith(currentState: StateTypes.submitting, error: null));
    try {
      final response = await repository.add(event.model);
      emit(state.copyWith(
        currentState: StateTypes.submitted,
        error: null,
        postdata: response, // Set postdata after submitting
      ));
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }

  // Load a list of suppliers
  Future<void> _onLoadData(LoadData event, Emitter<SupplierState> emit) async {
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

  // Load supplier by ID
  Future<void> _onLoadDataById(LoadDataById event, Emitter<SupplierState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading, error: null)); // Show loading state
    print("Loading supplier data for ID: ${event.Id}"); // Debug: Verify event ID
    try {
      final res = await repository.getById(event.Id); // Fetch supplier by ID
      if (res != null) {
        print("Supplier data loaded: ${res.code}"); // Debug: Verify loaded data
        emit(state.copyWith(
          currentState: StateTypes.loaded,
          error: null,
          postdata: res, // Set the supplier data
        ));
      } else {
        print("Supplier not found for ID: ${event.Id}"); // Debug: Verify not found
        emit(state.copyWith(currentState: StateTypes.error, error: 'Supplier not found'));
      }
    } catch (e) {
      print("Error loading supplier data: $e"); // Debug: Verify error
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString())); // Handle error
    }
  }

}



// State class for managing supplier states
class SupplierState {
  final StateTypes currentState;
  final String? error;
  final List<CustomerDTO>? data; // List of suppliers
  final CustomerDTO? postdata; // Single supplier

  SupplierState({
    this.currentState = StateTypes.init,
    this.error,
    this.data,
    this.postdata,
  });

  SupplierState copyWith({
    StateTypes? currentState,
    String? error,
    List<CustomerDTO>? data,
    CustomerDTO? postdata,
    bool clearData = false,
  }) {
    return SupplierState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      data: clearData ? null : (data ?? this.data),
      postdata: postdata ?? this.postdata,
    );
  }
}

// Events
abstract class SupplierEvent {}

class SubmitData extends SupplierEvent {
  final Map<String, dynamic> model;
  SubmitData({required this.model});
}

class LoadData extends SupplierEvent {
  final bool forceRefresh;
  LoadData({this.forceRefresh = false});
}

class LoadDataById extends SupplierEvent {
  final int Id;
  LoadDataById({required this.Id});
}
