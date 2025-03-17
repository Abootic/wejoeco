import '../models/MarketDTO.dart';
import '../repositories/MarketRepository.dart';
import '../utilities/state_types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define StateTypes for MarketState


class MarketBloc extends Bloc<MarketsEvent, MarketState> {
  final MarketRepository repository;

  MarketBloc({required this.repository}) : super(MarketState()) {
    on<Submit>(_onSubmit);
    on<LoadData>(_onLoadData);
  }

  // Handle the submit event
  Future<void> _onSubmit(Submit event, Emitter<MarketState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.submitting,
      error: null,
    ));

    try {
      final item = await repository.add(event.model);
      print("====== in submit, result: ${item.id}");

      emit(state.copyWith(
        currentState: StateTypes.submitted,
        error: null,
        model: item,
      ));
    } catch (e) {
      print("============ EXP in submit: ${e.toString()} ========");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  // Handle the load data event
  Future<void> _onLoadData(LoadData event, Emitter<MarketState> emit) async {
    emit(state.copyWith(
      currentState: StateTypes.loading,
      error: null,
    ));

    try {
      final items = await repository.getAll(refresh: event.forceRefresh);
      print("========= in bloc get all, count: ${items.result.length} ======");

      emit(state.copyWith(
        currentState: StateTypes.loaded,
        error: null,
        items: items.result,
        isFromCache: items.isFromCache,
      ));
    } catch (e) {
      print("=========EXP in bloc get all, count: ${e.toString()} ======");
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }
}

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

abstract class MarketsEvent {}

class Submit extends MarketsEvent {
  final Map<String, dynamic> model;

  Submit(this.model);
}

class LoadData extends MarketsEvent {
  final bool forceRefresh;

  LoadData({this.forceRefresh = false});
}
