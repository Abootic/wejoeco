import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/SupplierBloc.dart';
import '../../models/SupplierDTO.dart';  // Import your SupplierDTO model
import '../../repositories/SupplierRepository.dart';
import '../../utilities/state_types.dart';  // Import StateTypes for state management

class SupplierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupplierBloc(repository: RepositoryProvider.of<SupplierRepository>(context))
        ..add(LoadData(forceRefresh: true)),  // Automatically load data when the screen loads
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Suppliers11111111111',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              switch (state.currentState) {
                case StateTypes.loading:
                  return _buildLoadingState();
                case StateTypes.error:
                  return _buildErrorState(state.error ?? 'Something went wrong');
                case StateTypes.loaded:
                  return _buildSupplierList(state);
                case StateTypes.init:
                default:
                  return _buildInitialState();
              }
            },
          ),
        ),
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blueAccent),
          SizedBox(height: 10),
          Text("Loading..."),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          Text("Error: $errorMessage"),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Initial State - when no data is loaded
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No data available. Pull to refresh."),
        ],
      ),
    );
  }

  // Loaded State - Display the list of suppliers
  Widget _buildSupplierList(SupplierState state) {
    if (state.data == null || state.data!.isEmpty) {
      return Center(child: Text('No suppliers found.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Suppliers: ${state.data!.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: state.data!.length,
            itemBuilder: (context, index) {
              final supplier = state.data![index];
              return ListTile(
                title: Text(supplier.code!),  // Assuming `name` is a field in SupplierDTO
              );
            },
          ),
        ),
      ],
    );
  }
}
