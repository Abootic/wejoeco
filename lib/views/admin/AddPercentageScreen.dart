import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejoeco/bloc/PercentageBloc.dart' as PercentageBloc;
import 'package:wejoeco/bloc/SupplierBloc.dart' as SupplierBloc;
import '../../models/PercentageDTO.dart';
import '../../models/SupplierDTO.dart';
import '../../utilities/state_types.dart';

class AddPercentageScreen extends StatefulWidget {
  const AddPercentageScreen({super.key});

  @override
  _AddPercentageScreenState createState() => _AddPercentageScreenState();
}

class _AddPercentageScreenState extends State<AddPercentageScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _marketIdController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _percentageValueController = TextEditingController();
  int? _selectedSupplierId;

  @override
  void initState() {
    super.initState();
    context.read<SupplierBloc.SupplierBloc>().add(SupplierBloc.LoadData());
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final int supplierId = _selectedSupplierId ?? 0;
      final int marketId = int.tryParse(_marketIdController.text) ?? 0;
      final int priority = int.tryParse(_priorityController.text) ?? 0;
      final double percentageValue = double.tryParse(_percentageValueController.text) ?? 0.0;

      final newPercentage = PercentageDTO(
        supplierId: supplierId,
        marketId: marketId,
        priority: priority,
        percentageValue: percentageValue,
      );

      context.read<PercentageBloc.PercentageBloc>().add(
        PercentageBloc.Submit(int.parse(_marketIdController.text)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New percentage added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Percentage', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<SupplierBloc.SupplierBloc, SupplierBloc.SupplierState>(
          builder: (context, state) {
            if (state.currentState == StateTypes.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.currentState == StateTypes.error) {
              return Center(child: Text(state.error ?? 'Error loading suppliers'));
            }

            if (state.currentState == StateTypes.loaded && state.data != null) {

              final suppliers = state.data!;
              _marketIdController.text=suppliers.first.marketId.toString() ;
              if (suppliers.isEmpty) {
                return const Center(child: Text('No suppliers available'));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Supplier Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<int>(
                              value: _selectedSupplierId,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              hint: const Text('Select Supplier'),
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedSupplierId = newValue;
                                });
                              },
                              items: suppliers.map<DropdownMenuItem<int>>((SupplierDTO supplier) {
                                return DropdownMenuItem<int>(
                                  value: supplier.id,
                                  child: Text('Supplier ${supplier.id}'),
                                );
                              }).toList(),
                              validator: (value) => value == null ? 'Please select a supplier' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _marketIdController,
                              label: 'Market ID',
                              hint: 'Enter Market ID',
                              keyboardType: TextInputType.number,
                            ),



                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text('Unexpected state: ${state.currentState}'));
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
