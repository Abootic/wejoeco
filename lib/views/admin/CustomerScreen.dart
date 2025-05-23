import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/CustomerBloc.dart';
import '../../models/CustomerDTO.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';

class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomerScreenBody();
  }
}

class CustomerScreenBody extends StatefulWidget {
  @override
  _CustomerScreenBodyState createState() => _CustomerScreenBodyState();
}

class _CustomerScreenBodyState extends State<CustomerScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchType = 'id';
  List<CustomerDTO> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomersBloc>().add(LoadData());
    });
  }

  void _searchCustomer() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isEmpty) {
      _showAllCustomers();
      return;
    }

    final state = context.read<CustomersBloc>().state;
    if (state.currentState != StateTypes.loaded || state.data == null) {
      _showError('No customer data available');
      return;
    }

    setState(() {
      _isSearching = true;
      if (_searchType == 'id') {
        final searchId = int.tryParse(searchQuery);
        _filteredCustomers = searchId != null
            ? state.data!.where((customer) => customer.id == searchId).toList()
            : [];
      } else {
        _filteredCustomers = state.data!
            .where((customer) => customer.code
            ?.toLowerCase()
            .contains(searchQuery.toLowerCase()) ?? false)
            .toList();
      }
    });
  }

  void _showAllCustomers() {
    setState(() {
      _isSearching = false;
      _filteredCustomers = [];
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCustomerItem(CustomerDTO customer) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          customer.code ?? 'Unnamed Customer',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${customer.id}'),
            if (customer.code != null) Text('Code: ${customer.code}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _showAllCustomers,
              tooltip: 'Show all customers',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Search Customer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search term',
                        labelStyle: const TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _searchType,
                    items: const [
                      DropdownMenuItem(value: 'id', child: Text('By ID')),
                      DropdownMenuItem(value: 'code', child: Text('By Code')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _searchType = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _searchCustomer,
                    child: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Divider(height: 40),
              Text(
                _isSearching ? 'Search Results' : 'All Customers',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BlocBuilder<CustomersBloc, CustomerState>(
                builder: (context, state) {
                  if (state.currentState == StateTypes.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.currentState == StateTypes.error) {
                    return Center(
                      child: Column(
                        children: [
                          Text('Error: ${state.error}',
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<CustomersBloc>().add(LoadData()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state.currentState == StateTypes.loaded) {
                    final customersToDisplay = _isSearching ? _filteredCustomers : state.data!;

                    if (customersToDisplay.isEmpty) {
                      return Center(
                        child: Text(
                          _isSearching ? 'No matching customers found' : 'No customers available',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: customersToDisplay.length,
                      itemBuilder: (context, index) {
                        // Ensuring each customer card has a unique key to avoid conflicts.
                        return _buildCustomerItem(customersToDisplay[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
