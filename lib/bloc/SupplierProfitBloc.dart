import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/MarketDTO.dart';
import '../../repositories/MarketRepository.dart';
import '../../utilities/state_types.dart';
import '../models/SupplierProfitDTO.dart';
import '../models/SupplierProfitPercentageDTO.dart';
import '../repositories/SupplierProfitRepository.dart';

// Events
abstract class SupplierProfitEvent {}

class LoadData extends SupplierProfitEvent {
  final bool forceRefresh;
  final int supplier_id;

  LoadData({this.forceRefresh = false, required this.supplier_id});
}

class CalculateMarketProfit extends SupplierProfitEvent {
  final int id;
  CalculateMarketProfit(this.id);
}

class LoadProfitData extends SupplierProfitEvent {
  final int marketId;
  LoadProfitData(this.marketId);
}

class LoadProfitForSupplierData extends SupplierProfitEvent {
  final int userid;
  LoadProfitForSupplierData(this.userid);
}

class SupplierProfitState {
  final StateTypes currentState;
  final List<SupplierProfitDTO> items;
  final SupplierProfitPercentageDTO? percentageItem;  // Changed to single item
  final String error;

  SupplierProfitState({
    this.currentState = StateTypes.init,
    this.items = const [],
    this.percentageItem,
    this.error = '',
  });

  SupplierProfitState copyWith({
    StateTypes? currentState,
    List<SupplierProfitDTO>? items,
    SupplierProfitPercentageDTO? percentageItem,
    String? error,
  }) {
    return SupplierProfitState(
      currentState: currentState ?? this.currentState,
      items: items ?? this.items,
      percentageItem: percentageItem ?? this.percentageItem,
      error: error ?? this.error,
    );
  }
}

class SupplierProfitBloc extends Bloc<SupplierProfitEvent, SupplierProfitState> {
  final SupplierProfitRepository repository;

  SupplierProfitBloc({required this.repository})
      : super(SupplierProfitState()) {
    on<CalculateMarketProfit>(_onCalculateMarketProfit);
    on<LoadProfitData>(_onLoadProfitData);
    on<LoadProfitForSupplierData>(_onGetProfitBySupplierId);
  }

  Future<void> _onCalculateMarketProfit(
      CalculateMarketProfit event,
      Emitter<SupplierProfitState> emit,
      ) async {
    emit(state.copyWith(currentState: StateTypes.loading));

    try {
      final profit = await repository.CalculateMarketProfit(event.id);
      emit(state.copyWith(
        currentState: StateTypes.loaded,
        items: profit,
      ));
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadProfitData(
      LoadProfitData event,
      Emitter<SupplierProfitState> emit,
      ) async {
    emit(state.copyWith(currentState: StateTypes.loading));

    try {
      final profits = await repository.getAll();
      emit(state.copyWith(
        currentState: StateTypes.loaded,
        items: profits.result,
      ));
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onGetProfitBySupplierId(
      LoadProfitForSupplierData event,
      Emitter<SupplierProfitState> emit,
      ) async {
    emit(state.copyWith(currentState: StateTypes.loading));

    try {
      final profit = await repository.getProfitBySupplierId(event.userid);

      emit(state.copyWith(
        currentState: StateTypes.loaded,
        percentageItem: profit,
      ));
    } catch (e) {
      emit(state.copyWith(
        currentState: StateTypes.error,
        error: e.toString(),
      ));
    }
  }
}