import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/OrderBloc.dart';
import '../../repositories/SharedRepository.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';


class CartScreen extends StatelessWidget {
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();

  CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return buildErrorWidget("Unable to fetch user ID. Please try again.");
        }

        final userId = snapshot.data;
        context.read<OrderBloc>().add(LoadDataByUserid(Userid: userId!));

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Cart'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.currentState == StateTypes.loading) {
                  return _buildShimmerLoading();
                }

                if (state.currentState == StateTypes.error) {
                  return buildErrorWidget(state.error ?? "An error occurred.");
                }

                if (state.currentState == StateTypes.loaded) {
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Text("Your cart is empty 🛒"),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final order = state.items[index];
                      return _buildCartItem(context, order, userId);
                    },
                  );
                }

                return buildErrorWidget("No data available.");
              },
            ),
          ),
        );
      },
    );
  }

  Future<int?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userIdString = prefs.getString("userId");
    return userIdString != null ? int.tryParse(userIdString) : null;
  }

  Widget _buildCartItem(BuildContext context, dynamic order, int userId) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.2),
          child: const Icon(Icons.shopping_bag, color: AppColors.primary),
        ),
        title: Text(
          "Order #${order.id}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "Price: SAR ${order.price}",
          style: const TextStyle(fontSize: 14, color: AppColors.hintText),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total: SAR ${order.price}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () => _confirmDelete(context, order.id, userId),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int orderId, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to remove this item from your cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<OrderBloc>().add(DeleteOrder(orderId: orderId));
                context.read<OrderBloc>().add(LoadDataByUserid(Userid: userId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Delete", style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white),
              title: Container(height: 10, width: 80, color: Colors.white),
              subtitle: Container(height: 10, width: 100, color: Colors.white),
              trailing: Container(height: 10, width: 60, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}