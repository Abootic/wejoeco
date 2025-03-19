import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/MarketDTO.dart';
import '../repositories/MarketRepository.dart';
import '../utilities/state_types.dart';

// Market Bloc to handle events
class MarketBloc extends Bloc<MarketsEvent, MarketState> {
  final MarketRepository repository;

  MarketBloc({required this.repository}) : super(MarketState()) {
    on<Submit>(_onSubmit);
    on<LoadData>(_onLoadData);
  }

  Future<void> _onSubmit(Submit event, Emitter<MarketState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));

    try {
      final item = await repository.add(event.model);
      print("Market added with id: ${item.id}");

      final updatedItems = List<MarketDTO>.from(state.items)..add(item);
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

  Future<void> _onLoadData(LoadData event, Emitter<MarketState> emit) async {
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
}
// MarketState class to hold the state of markets and other necessary data
class MarketState {
  final StateTypes currentState;
  final String? error;
  final List<MarketDTO> items;
  final MarketDTO? model;
  final bool isFromCache;

  MarketState({
    this.currentState = StateTypes.init,
    this.error,
    this.items = const [],
    this.isFromCache = false,
    this.model,
  });

  // Helper method to copy state with changes
  MarketState copyWith({
    StateTypes? currentState,
    String? error,
    List<MarketDTO>? items,
    bool? isFromCache,
    MarketDTO? model,
  }) {
    return MarketState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      items: items ?? this.items,
      isFromCache: isFromCache ?? this.isFromCache,
      model: model ?? this.model,
    );
  }
}

// Abstract class for events
abstract class MarketsEvent {}

class Submit extends MarketsEvent {
  final Map<String, dynamic> model;

  Submit(this.model);
}

class LoadData extends MarketsEvent {
  final bool forceRefresh;

  LoadData({this.forceRefresh = false});
}
