import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../bloc/SupplierBloc.dart';
import '../../models/SupplierDTO.dart';
import '../../repositories/SharedRepository.dart';
import '../../repositories/SupplierRepository.dart';
import '../../utilities/state_types.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key});

  @override
  _SupplierState createState() => _SupplierState();
}


class _SupplierState extends State<Supplier> {
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
  bool _isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      String fetchedUserId = await _sharedRepository.getData("userId");
      setState(() {
        userId = fetchedUserId;
        _isLoading = false;
      });

      if (userId != null) {
        print("Loaded userId: $userId");
        BlocProvider.of<SupplierBloc>(context).add(LoadDataById(Id: int.parse(userId!)));
        print("Dispatched LoadDataById event for userId: $userId");
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Supplier')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, state) {
            print("BlocBuilder rebuild: ${state.currentState}");
            if (_isLoading) {
              return _buildLoadingState();
            }
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
    );
  }

  Widget _buildInitialState() {
    return Center(child: Text('Press the button to load supplier'));
  }

  Widget _buildLoadingState() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(child: Text('Error: $errorMessage'));
  }

  Widget _buildSupplierDetails(SupplierDTO? supplier, BuildContext context) {
    if (supplier == null) {
      return Center(child: Text('No supplier found'));
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