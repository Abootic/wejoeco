import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/MarketDTO.dart';
import '../../repositories/MarketRepository.dart';
import '../../utilities/state_types.dart';

// Events
abstract class MarketEvent {}

class LoadData extends MarketEvent {
  final bool forceRefresh;
  LoadData({this.forceRefresh = false});
}


class Submit extends MarketEvent {
  final Map<String, dynamic> model;
  Submit(this.model);
}


// State
class MarketState {
  final StateTypes currentState;
  final List<MarketDTO> items;
  final String error;
  final int selectedIndex; // Added to track which card is selected

  MarketState({
    this.currentState = StateTypes.init,
    this.items = const [],
    this.error = '',
    this.selectedIndex = -1, // Default to no card selected
  });

  MarketState copyWith({
    StateTypes? currentState,
    List<MarketDTO>? items,
    String? error,
    int? selectedIndex,
  }) {
    print("Updating state: currentState=$currentState, items=${items?.length}, error=$error, selectedIndex=$selectedIndex"); // Debugging
    return MarketState(
      currentState: currentState ?? this.currentState,
      items: items ?? this.items,
      error: error ?? this.error,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarketState &&
        other.currentState == currentState &&
        other.items == items &&
        other.error == error &&
        other.selectedIndex == selectedIndex;
  }

  @override
  int get hashCode => currentState.hashCode ^ items.hashCode ^ error.hashCode ^ selectedIndex.hashCode;
}

// Bloc
class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository repository;

  MarketBloc({required this.repository}) : super(MarketState()) {
    on<LoadData>(_onLoadData);
    on<Submit>(_onSubmit);
  }

  Future<void> _onLoadData(LoadData event, Emitter<MarketState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading));

    try {
      final markets = await repository.getAll(refresh: event.forceRefresh);
      print("Fetched markets: ${markets.result}"); // Debugging
      emit(state.copyWith(
        currentState: StateTypes.loaded,
        items: markets.result,
      ));
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }

  Future<void> _onSubmit(Submit event, Emitter<MarketState> emit) async {
    emit(state.copyWith(currentState: StateTypes.submitting));

    try {
      await repository.add(event.model);
      // After adding, reload the data
      add(LoadData());
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }

  // Handle the card tap event

}
