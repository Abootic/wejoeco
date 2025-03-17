import 'package:flutter/material.dart';

class Totalprofit extends StatelessWidget {
  const Totalprofit({super.key});

  // Sample data for suppliers
  final List<Map<String, String>> suppliers = const [
    {
      'name': 'Supplier 1',
      'totalProfit': '\$10,000',
      'investment': '\$5,000',
    },
    {
      'name': 'Supplier 2',
      'totalProfit': '\$15,000',
      'investment': '\$7,000',
    },
    {
      'name': 'Supplier 3',
      'totalProfit': '\$20,000',
      'investment': '\$10,000',
    },
    {
      'name': 'Supplier 4',
      'totalProfit': '\$12,000',
      'investment': '\$6,000',
    },
    {
      'name': 'Supplier 5',
      'totalProfit': '\$18,000',
      'investment': '\$9,000',
    },
  ];

  // Function to calculate total profit of all suppliers
  String calculateTotalProfit() {
    double totalProfit = 0;
    for (var supplier in suppliers) {
      // Remove the dollar sign and comma, then parse to double
      String profit = supplier['totalProfit']!.replaceAll('\$', '').replaceAll(',', '');
      totalProfit += double.parse(profit);
    }
    return '\$${totalProfit.toStringAsFixed(2)}'; // Format to 2 decimal places
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Total Profit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Section
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50], // Light blue background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Profit of All Suppliers:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  calculateTotalProfit(), // Display total profit
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // List of Suppliers
          Expanded(
            child: ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      supplier['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Total Profit: ${supplier['totalProfit']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Investment: ${supplier['investment']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}