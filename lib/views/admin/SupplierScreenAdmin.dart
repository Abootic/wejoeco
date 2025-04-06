import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/SupplierBloc.dart';
import '../../models/SupplierDTO.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchType = 'id'; // 'id' or 'code'
  List<SupplierDTO> _filteredSuppliers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupplierBloc>().add(LoadData());
    });
  }

  void _searchSupplier() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isEmpty) {
      // Reset to show all suppliers when search is empty
      _showAllSuppliers();
      return;
    }

    final state = context.read<SupplierBloc>().state;
    if (state.currentState != StateTypes.loaded || state.data == null) {
      _showError('No supplier data available');
      return;
    }

    setState(() {
      _isSearching = true;
      if (_searchType == 'id') {
        final searchId = int.tryParse(searchQuery);
        _filteredSuppliers = searchId != null
            ? state.data!.where((supplier) => supplier.id == searchId).toList()
            : [];
      } else {
        _filteredSuppliers = state.data!
            .where((supplier) => supplier.code
            ?.toLowerCase()
            .contains(searchQuery.toLowerCase()) ?? false)
            .toList();
      }
    });
  }

  void _showAllSuppliers() {
    setState(() {
      _isSearching = false;
      _filteredSuppliers = [];
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

  Widget _buildSupplierItem(SupplierDTO supplier) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          supplier.code ?? 'Unnamed Supplier',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${supplier.id}'),
            if (supplier.code != null) Text('Code: ${supplier.code}'),
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
          'Supplier Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _showAllSuppliers,
              tooltip: 'Show all suppliers',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Allow scrolling for the entire screen
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Section
              const Text(
                'Search Supplier',
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
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _searchType,
                    items: const [
                      DropdownMenuItem(
                        value: 'id',
                        child: Text('By ID'),
                      ),
                      DropdownMenuItem(
                        value: 'code',
                        child: Text('By Code'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _searchType = value!;
                      });
                    },
                    dropdownColor: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _searchSupplier,
                    child: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
              const Divider(height: 40),

              // Supplier List Section
              Text(
                _isSearching ? 'Search Results' : 'All Suppliers',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // ListView will be inside an Expanded to allow scrolling
              BlocBuilder<SupplierBloc, SupplierState>(
                builder: (context, state) {
                  if (state.currentState == StateTypes.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.currentState == StateTypes.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${state.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<SupplierBloc>().add(LoadData()),
                            child: const Text('Retry'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  } else if (state.currentState == StateTypes.empty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No suppliers found'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<SupplierBloc>().add(LoadData()),
                            child: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  } else if (state.currentState == StateTypes.loaded) {
                    final suppliersToDisplay = _isSearching ? _filteredSuppliers : state.data!;

                    if (suppliersToDisplay.isEmpty) {
                      return Center(
                        child: Text(
                          _isSearching ? 'No matching suppliers found' : 'No suppliers available',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true, // Allow ListView to take only as much space as needed
                      physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling to allow scrollable parent
                      itemCount: suppliersToDisplay.length,
                      itemBuilder: (context, index) {
                        return _buildSupplierItem(suppliersToDisplay[index]);
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
