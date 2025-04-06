import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/SupplierProfitBloc.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';

import 'package:get_it/get_it.dart';
import '../../repositories/SharedRepository.dart';
import 'package:pie_chart/pie_chart.dart';

class TotalProfit extends StatefulWidget {
  const TotalProfit({super.key});

  @override
  _TotalProfitState createState() => _TotalProfitState();
}

class _TotalProfitState extends State<TotalProfit> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
      final userId = await _sharedRepository.getData("userId");
      if (userId != null) {
        BlocProvider.of<SupplierProfitBloc>(context).add(
          LoadProfitForSupplierData(int.parse(userId)),
        );
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// Function to determine color based on percentage value
  Color getColorForPercentage(double percentage) {
    if (percentage >= 75.0) {
      return Colors.greenAccent; // High profit: Green
    } else if (percentage >= 50.0) {
      return Colors.blueAccent; // Moderate profit: Blue
    } else if (percentage >= 25.0) {
      return Colors.orangeAccent; // Low profit: Orange
    } else {
      return Colors.redAccent; // Very low profit: Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Total Profit',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<SupplierProfitBloc, SupplierProfitState>(
          builder: (context, state) {
            if (state.currentState == StateTypes.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.currentState == StateTypes.error) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state.percentageItem == null || state.percentageItem!.profitData?.profit == null) {
              return const Center(child: Text('No profit data available'));
            }

            final profit = state.percentageItem!.profitData!.profit!;
            final supplier = state.percentageItem!.supplier;
            final supplierCode = supplier?.code ?? 'Unknown';

            // Extract percentage data for chart
            final chartData = <String, double>{};
            String percentageText = "0.0%"; // Default
            Color dynamicColor = Colors.grey; // Default color

            if (state.percentageItem?.percentageData != null) {
              final percentageValue = state.percentageItem!.percentageData!.percentageValue ?? 0.0;

              // Assign dynamic color based on percentage
              dynamicColor = getColorForPercentage(percentageValue);

              chartData[supplierCode] = percentageValue;
              percentageText = "${percentageValue.toStringAsFixed(2)}%";
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Total Profit Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withOpacity(0.8), AppColors.primary.withOpacity(0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Profit: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonText,
                          ),
                        ),
                        Text(
                          '\$${profit.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pie Chart with Dynamic Color
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 300,
                    child: PieChart(
                      dataMap: chartData,
                      chartType: ChartType.ring,
                      colorList: [dynamicColor], // Assigning dynamic color
                      animationDuration: const Duration(seconds: 2),
                      ringStrokeWidth: 32,
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: false,
                        showChartValues: true,
                        showChartValuesInPercentage: false, // Shows actual values
                        decimalPlaces: 2, // Keep values formatted
                        chartValueStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      legendOptions: const LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.left,
                        legendTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  // Explicitly Display Percentage Value
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Percentage: $percentageText",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Supplier Details Card
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(
                        supplierCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Profit: \$${profit.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Market ID: ${supplier?.marketId?.toString() ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Join Date: ${supplier?.joinDate != null ? DateFormat('yyyy-MM-dd').format(supplier!.joinDate!) : 'N/A'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
