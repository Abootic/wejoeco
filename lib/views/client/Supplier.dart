import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../bloc/SupplierBloc.dart';
import '../../models/SupplierDTO.dart';
import '../../repositories/SharedRepository.dart';
import '../../utilities/state_types.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key});

  @override
  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserId();
    });
  }

  Future<void> _loadUserId() async {
    try {
      String? fetchedUserId = await _sharedRepository.getData("userId");
      if (!mounted) return;

      setState(() {
        userId = fetchedUserId;
      });

      if (userId != null) {
        BlocProvider.of<SupplierBloc>(context).add(LoadDataById(Id: int.parse(userId!)));
      }
    } catch (e) {
      print("Error loading userId: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Supplier'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              switch (state.currentState) {
                case StateTypes.loading:
                  return _buildLoadingState();
                case StateTypes.error:
                  return _buildErrorState(state.error ?? 'Something went wrong');
                case StateTypes.loaded:
                  return _buildSupplierDetails(state.postdata, context);
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

  Widget _buildInitialState() {
    return const Center(child: Text('Press the button to load supplier'));
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(child: Text('Error: $errorMessage'));
  }

  Widget _buildSupplierDetails(SupplierDTO? supplier, BuildContext context) {
    if (supplier == null) {
      return const Center(child: Text('No supplier found'));
    }
    return Card(
      child: ListTile(
        title: Text(supplier.code ?? 'No code available'),
        subtitle: Text('ID: ${supplier.id}'),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${supplier.code} selected!')),
        ),
      ),
    );
  }
}
