import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/PercentageDTO.dart';
import '../../bloc/PercentageBloc.dart';
import '../../repositories/PercentageRepository.dart';
import '../../utilities/state_types.dart';
import 'AddPercentageScreen.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  _PercentageScreenState createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading data when screen initializes
    context.read<PercentageBloc>().add(LoadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage Data'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Percentage Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 16),

            // BlocBuilder to listen to state changes
            Expanded(
              child: BlocBuilder<PercentageBloc, PercentageState>(
                builder: (context, state) {
                  if (state.currentState == StateTypes.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.currentState == StateTypes.error) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No percentage data available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final percentage = state.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'Supplier ${percentage.supplierId ?? "N/A"} - Market ${percentage.marketId ?? "N/A"}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          subtitle: Text(
                            'Priority: ${percentage.priority}\nPercentage Value: ${percentage.percentageValue}%',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                          onTap: () => _showPercentageDetails(context, percentage),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Add Percentage Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPercentageScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add New Percentage',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show details of selected percentage entry
  void _showPercentageDetails(BuildContext context, PercentageDTO percentage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Percentage Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Supplier ID: ${percentage.supplierId ?? "N/A"}'),
              Text('Market ID: ${percentage.marketId ?? "N/A"}'),
              Text('Priority: ${percentage.priority}'),
              Text('Percentage Value: ${percentage.percentageValue}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
