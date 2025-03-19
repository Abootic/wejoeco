import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ProductDTO.dart';
import '../repositories/ProductRepository.dart';
import '../utilities/state_types.dart';

// ProductBloc that handles events and emits states
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductState()) {
    on<SubmitProductData>(_onSubmit);
    on<LoadProductData>(_onLoadData);
    //on<LoadProductDataById>(_onLoadDataById);
  }

  // Submit product data
  Future<void> _onSubmit(SubmitProductData event, Emitter<ProductState> emit) async {
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

  // Load a list of products
  Future<void> _onLoadData(LoadProductData event, Emitter<ProductState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading, error: null));
    try {
      final items = await repository.getAll(refresh: event.forceRefresh);
      print("========================== image is ===================");
     for(int i=0;i<items.result.length;i++){
       print(items.result[i].image);
     }
      emit(state.copyWith(
        currentState: StateTypes.loaded,
        error: null,
        data: items.result,
      ));
    } catch (e) {
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString()));
    }
  }

  // Load product by ID
/*
  Future<void> _onLoadDataById(LoadProductDataById event, Emitter<ProductState> emit) async {
    emit(state.copyWith(currentState: StateTypes.loading, error: null)); // Show loading state
    print("Loading product data for ID: ${event.Id}"); // Debug: Verify event ID
    try {
      final res = await repository.getById(event.Id); // Fetch product by ID
      if (res != null) {
        print("Product data loaded: ${res.productId}"); // Debug: Verify loaded data
        emit(state.copyWith(
          currentState: StateTypes.loaded,
          error: null,
          postdata: res, // Set the product data
        ));
      } else {
        print("Product not found for ID: ${event.Id}"); // Debug: Verify not found
        emit(state.copyWith(currentState: StateTypes.error, error: 'Product not found'));
      }
    } catch (e) {
      print("Error loading product data: $e"); // Debug: Verify error
      emit(state.copyWith(currentState: StateTypes.error, error: e.toString())); // Handle error
    }
  }
*/


}

// State class for managing product states
class ProductState {
  final StateTypes currentState;
  final String? error;
  final List<ProductDTO>? data; // List of products
  final ProductDTO? postdata; // Single product

  ProductState({
    this.currentState = StateTypes.init,
    this.error,
    this.data,
    this.postdata,
  });

  ProductState copyWith({
    StateTypes? currentState,
    String? error,
    List<ProductDTO>? data,
    ProductDTO? postdata,
    bool clearData = false,
  }) {
    return ProductState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      data: clearData ? null : (data ?? this.data),
      postdata: postdata ?? this.postdata,
    );
  }
}

// Events
abstract class ProductEvent {}

class SubmitProductData extends ProductEvent {
  final Map<String, dynamic> model;
  SubmitProductData({required this.model});
}

class LoadProductData extends ProductEvent {
  final bool forceRefresh;
  LoadProductData({this.forceRefresh = false});
}

/*class LoadProductDataById extends ProductEvent {
  final int Id;
  LoadProductDataById({required this.Id});
}*/
