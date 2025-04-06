import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/OrderDTO.dart';
import '../repositories/OrderRepository.dart';
import '../repositories/SharedRepository.dart';
import '../utilities/state_types.dart';
import 'package:get_it/get_it.dart';

// Order Bloc to handle events
class OrderBloc extends Bloc<OrdersEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderState()) {
    on<Submit>(_onSubmit);
    on<LoadData>(_onLoadData);
    on<LoadDataByUserid>(_onLoadDataById);
    on<DeleteOrder>(_onDeleteOrder);
  }

  Future<void> _onSubmit(Submit event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));

    try {
      final item = await repository.add(event.model);
      print("Order added with orderdata in order bloc in _onSubmit is  ${jsonEncode(item)}");

      final updatedItems = List<OrderDTO>.from(state.items)..add(item);
      print("Updated items: ${updatedItems.length}");

      emit(state.copyWith(
        currentState: StateTypes.submitted,
        error: null,
        items: updatedItems,
      ));
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadData(LoadData event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.loading,
      error: null,
    ));

    try {
      final items = await repository.getAll(refresh: event.forceRefresh);
      emit(state.copyWith(
        currentState: StateTypes.loaded,
        error: null,
        items: items.result,
        isFromCache: items.isFromCache,
      ));
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadDataById(LoadDataByUserid event, Emitter<OrderState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading, error: null)); // Show loading state
    print("Loading order data for ID: ${event.Userid}"); // Debug: Verify event ID
    try {
      final res = await repository.getByUserId(event.Userid); // Fetch supplier by ID
      if (res != null) {
        for(int i=0;i<res.length;i++){
          print("order data loaded: ${res[i].id}"); // Debug: Verify loaded data
        }

        emit(state.copyWith(
          currentState: StateTypes.loaded,
          error: null,
          items: res, // Set the supplier data
        ));
      } else {
        print("order not found for ID: ${event.Userid}"); // Debug: Verify not found
        emit(state.copyWith(currentState: StateTypes.error, error: 'Supplier not found'));
      }
    } catch (e) {
      print("Error loading supplier data: $e"); // Debug: Verify error
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString())); // Handle error
    }
  }
  Future<void> _onDeleteOrder(DeleteOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));

    try {
      // Call the remove method to delete the order
      await repository.remove(event.orderId);

      // After successful deletion, filter out the deleted order from the list
      final updatedItems = List<OrderDTO>.from(state.items)
        ..removeWhere((order) => order.id == event.orderId);

      emit(state.copyWith(
        currentState: StateTypes.submitted,
        error: null,
        items: updatedItems,
      ));

      // Get the userId from SharedRepository before calling LoadDataByUserid
      final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
      final userIdString = await _sharedRepository.getData("userId");

      if (userIdString != null) {
        // Attempt to parse the userId as an integer
        final userId = int.tryParse(userIdString);

        if (userId != null) {
          // Call LoadDataByUserid to reload data after deletion, using the fetched userId
          add(LoadDataByUserid(Userid: userId));
        } else {
          emit(state.copyWith(
            currentState: StateTypes.error,
            error: 'Invalid userId in SharedPreferences',
          ));
        }
      } else {
        emit(state.copyWith(
          currentState: StateTypes.error,
          error: 'UserId not found in SharedPreferences',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

}

// OrderState class to hold the state of orders and other necessary data
class OrderState {
  final StateTypes currentState;
  final String? error;
  final List<OrderDTO> items;
  final OrderDTO? model;
  final bool isFromCache;

  OrderState({
    this.currentState = StateTypes.init,
    this.error,
    this.items = const [],
    this.isFromCache = false,
    this.model,
  });

  // Helper method to copy state with changes
  OrderState copyWith({
    StateTypes? currentState,
    String? error,
    List<OrderDTO>? items,
    bool? isFromCache,
    OrderDTO? model,
  }) {
    return OrderState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      items: items ?? this.items,
      isFromCache: isFromCache ?? this.isFromCache,
      model: model ?? this.model,
    );
  }
}

// Abstract class for events
abstract class OrdersEvent {}

class Submit extends OrdersEvent {
  final Map<String, dynamic> model;

  Submit(this.model);
}

class LoadData extends OrdersEvent {
  final bool forceRefresh;

  LoadData({this.forceRefresh = false});
}
class LoadDataByUserid extends OrdersEvent {
  final int Userid;
  LoadDataByUserid({required this.Userid});
}
class DeleteOrder extends OrdersEvent {
  final int orderId;
  DeleteOrder({required this.orderId});
}