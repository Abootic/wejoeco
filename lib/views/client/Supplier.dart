import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../bloc/SupplierBloc.dart';
import '../../models/SupplierDTO.dart';
import '../../repositories/SharedRepository.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';


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
      print("Fetched User ID: $fetchedUserId");
      if (!mounted) return;

      setState(() {
        userId = fetchedUserId;
      });

      if (userId != null && userId!.isNotEmpty) {
        final int parsedId = int.tryParse(userId!) ?? -1;
        if (parsedId > 0) {
          print("Dispatching LoadDataById event for userId: $parsedId");
          context.read<SupplierBloc>().add(LoadDataById(Id: parsedId));
        } else {
          print("Invalid userId format");
        }
      }
    } catch (e) {
      print("Error loading userId: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Supplier')),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              switch (state.currentState) {
                case StateTypes.loading:
                  return buildLoadingWidget();
                case StateTypes.error:
                  return buildErrorWidget(state.error ?? 'Something went wrong');
                case StateTypes.loaded:
                  return _buildSupplierDetails(state.singleData as SupplierDTO?, context);
                case StateTypes.init:
                default:
                  return buildErrorWidget("No data available.");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierDetails(SupplierDTO? supplier, BuildContext context) {
    if (supplier == null) {
      return Center(child: Text("Supplier data is not available."));
    }
    print("SupplierDTO Data: ${supplier.toString()}");
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
