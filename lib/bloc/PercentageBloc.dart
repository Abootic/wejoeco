import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/MarketDTO.dart';
import '../models/PercentageDTO.dart';
import '../repositories/PercentageRepository.dart';
import '../utilities/state_types.dart';

// Market Bloc to handle events
class PercentageBloc extends Bloc<PercentageEvent, PercentageState> {
  final PercentageRepository repository;

  PercentageBloc({required this.repository}) : super(PercentageState()) {
    on<Submit>(_onSubmit);
    on<LoadData>(_onLoadData);
  }

  Future<void> _onSubmit(Submit event, Emitter<PercentageState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));
    print("Percentage data is ${jsonEncode( event.id)}");

    try {
      final item = await repository.add(event.id);
      print("Market added with id: ${item.marketId}");

      final updatedItems = List<PercentageDTO>.from(state.items)..add(item);
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

  Future<void> _onLoadData(LoadData event, Emitter<PercentageState> emit) async {
    print("this is a _onLoadData in PercentageBloc ");
    emit(state.copyWith(
      currentState: StateTypes.loading,
      error: null,
    ));

    try {
      final items = await repository.getAll(refresh: event.forceRefresh);
      print("====================================== start all percntage data in percentage bloc ======");
      print(jsonEncode(items.result));
      print("====================================== end all percntage data in percentage bloc ======");
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

}
// MarketState class to hold the state of markets and other necessary data
class PercentageState {
  final StateTypes currentState;
  final String? error;
  final List<PercentageDTO> items;
  final PercentageDTO? model;
  final bool isFromCache;

  PercentageState({
    this.currentState = StateTypes.init,
    this.error,
    this.items = const [],
    this.isFromCache = false,
    this.model,
  });

  // Helper method to copy state with changes
  PercentageState copyWith({
    StateTypes? currentState,
    String? error,
    List<PercentageDTO>? items,
    bool? isFromCache,
    PercentageDTO? model,
  }) {
    return PercentageState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      items: items ?? this.items,
      isFromCache: isFromCache ?? this.isFromCache,
      model: model ?? this.model,
    );
  }
}

// Abstract class for events
abstract class PercentageEvent {}

class Submit extends PercentageEvent {
  final int id;

  Submit(this.id);
}

class LoadData extends PercentageEvent {
  final bool forceRefresh;

  LoadData({this.forceRefresh = false});
}
