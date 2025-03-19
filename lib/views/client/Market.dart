import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/MarketBloc.dart';
import '../../models/MarketDTO.dart';
import '../../repositories/MarketRepository.dart';
import '../../utilities/state_types.dart';
import 'package:get_it/get_it.dart';

class Market extends StatelessWidget {
  const Market({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarketBloc(repository: GetIt.instance<MarketRepository>())
        ..add(LoadData()), // Dispatch the LoadData event when MarketScreen is created
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Markets"),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0,
        ),
        body: BlocBuilder<MarketBloc, MarketState>(
          builder: (context, state) {
            print("Current state: ${state.currentState}, Items: ${state.items.length}");
            if (state.currentState == StateTypes.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.currentState == StateTypes.error) {
              return Center(
                child: Text('Error: ${state.error}', style: TextStyle(color: Colors.red)),
              );
            }

            if (state.currentState == StateTypes.loaded || state.currentState == StateTypes.submitted) {
              return _buildMarketList(state.items);
            }

            return const Center(child: Text("No data available"));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddMarketDialog(context);
          },
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMarketList(List<MarketDTO> items) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final market = items[index];
          return _buildMarketCard(market);
        },
      ),
    );
  }

  Widget _buildMarketCard(MarketDTO market) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          market.name ?? 'Unnamed Market',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          market.id != null ? 'ID: ${market.id}' : 'ID: Not Available',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        leading: const Icon(
          Icons.storefront,
          size: 36,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  void _showAddMarketDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Market"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Market Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  // Trigger the Submit event with the new market data
                  context.read<MarketBloc>().add(Submit({'name': name}));
                  Navigator.of(context).pop();  // Close the dialog
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
