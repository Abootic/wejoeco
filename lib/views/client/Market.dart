import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/MarketBloc.dart';
import '../../models/MarketDTO.dart';
import '../../models/SupplierProfitDTO.dart';
import '../../repositories/MarketRepository.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';
import '../../bloc/SupplierProfitBloc.dart' as SupplierProfitBloc;

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  int? selectedIndex; // Track the selected index
  Map<int, double> marketProfits = {}; // Store calculated market profits for each market

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarketBloc(repository: GetIt.instance<MarketRepository>())
        ..add(LoadData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Markets"),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<MarketBloc, MarketState>(
          builder: (context, state) {
            if (state.currentState == StateTypes.loading) {
              return buildLoadingWidget();
            }

            if (state.currentState == StateTypes.error) {
              return buildErrorWidget(state.error ?? "An error occurred.");
            }

            if (state.currentState == StateTypes.loaded || state.currentState == StateTypes.submitted) {
              return _buildMarketList(state.items);
            }

            return buildErrorWidget("No data available.");
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddMarketDialog(context),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  Widget _buildMarketList(List<MarketDTO> items) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.padding),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final market = items[index];
          return _buildMarketCard(market, index);
        },
      ),
    );
  }

  Widget _buildMarketCard(MarketDTO market, int index) {
    bool isSelected = selectedIndex == index; // Check if the card is selected

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = isSelected ? null : index; // Toggle selection
        });
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey[300]!, // Change color when selected
            width: 2,
          ),
        ),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(20),
              title: Text(
                market.name ?? 'Unnamed Market',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              subtitle: Text(
                market.id != null ? 'ID: ${market.id}' : 'ID: Not Available',
                style: const TextStyle(fontSize: 14, color: AppColors.hintText),
              ),
              leading: const Icon(
                Icons.storefront,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<SupplierProfitBloc.SupplierProfitBloc>().add(
                        SupplierProfitBloc.CalculateMarketProfit(market.id!),
                      );
                    },
                    child: const Text("Calculate Profit", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SupplierProfitBloc.SupplierProfitBloc>().add(
                        SupplierProfitBloc.LoadProfitData(market.id!),
                      );
                    },
                    child: const Text("List Profit", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
            if (marketProfits.containsKey(market.id))
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Profit: ${marketProfits[market.id]?.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            BlocBuilder<SupplierProfitBloc.SupplierProfitBloc, SupplierProfitBloc.SupplierProfitState>(
              builder: (context, state) {
                if (state.currentState == StateTypes.loading) {
                  return const CircularProgressIndicator();
                } else if (state.currentState == StateTypes.loaded) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: state.items.map((profit) {
                        return ListTile(
                          title: Text('Supplier: ${profit.supplier?.code ?? "Unknown"}'),
                          subtitle: Text('Profit: ${profit.profit?.toStringAsFixed(2)}'),
                        );
                      }).toList(),
                    ),
                  );
                } else if (state.currentState == StateTypes.error) {
                  return Text('Error: ${state.error}');
                }
                return Container();
              },
            ),
          ],
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
                decoration: AppStyles.inputDecoration('Market Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  context.read<MarketBloc>().add(Submit({'name': name}));
                  Navigator.of(context).pop();
                }
              },
              style: AppStyles.elevatedButtonStyle(AppColors.primary),
              child: const Text("Add", style: TextStyle(color: AppColors.buttonText)),
            ),
          ],
        );
      },
    );
  }
}
