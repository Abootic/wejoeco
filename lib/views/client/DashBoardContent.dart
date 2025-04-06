import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/OrderBloc.dart' as o;
import '../../bloc/ProductBloc.dart';
import '../../models/ProductDTO.dart';
import '../../repositories/SharedRepository.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';
import 'Cart_Screen.dart';
import 'package:get_it/get_it.dart';
class DashBoardContent extends StatefulWidget {
  const DashBoardContent({super.key});

  @override
  _DashBoardContentState createState() => _DashBoardContentState();
}

class _DashBoardContentState extends State<DashBoardContent> {
  String userType = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _getUserType();
    _getUserId();
    context.read<ProductBloc>().add(LoadProductData());
  }

  Future<void> _getUserType() async {
    final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
    userType = await _sharedRepository.getData("userType") ?? '';
    setState(() {});
  }

  Future<void> _getUserId() async {
    final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
    userId = await _sharedRepository.getData("userId") ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.currentState == StateTypes.loading) {
          return buildLoadingWidget();
        } else if (state.currentState == StateTypes.error) {
          return buildErrorWidget(state.error ?? "An error occurred.");
        } else if (state.data != null && state.data!.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(AppStyles.padding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: state.data!.length,
            itemBuilder: (context, index) {
              final product = state.data![index];
              return _buildProductItem(context, product);
            },
          );
        }
        return buildErrorWidget("No products available.");
      },
    );
  }

  Widget _buildProductItem(BuildContext context, ProductDTO product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProductImage(product.image),
          Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: Text(
              product.name ?? 'No Name',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'SAR ${product.price ?? 0}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding),
            child: ElevatedButton(
              style: AppStyles.elevatedButtonStyle(AppColors.primary),
              onPressed: userType == 'CUSTOMER'
                  ? () {
                final orderData = {
                  'product_name': product.name,
                  'price': product.price,
                  'product_id': product.id,
                  'quantity': 1,
                  'user_id': userId,
                };
                context.read<o.OrderBloc>().add(o.Submit(orderData));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              }
                  : null,
              child: const Text('+ Add to Cart', style: TextStyle(color: AppColors.buttonText)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    const String baseUrl = 'http://127.0.0.1:8008/upload/products';
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final fullUrl = '$baseUrl/$imageUrl';
      return Image.network(
        fullUrl,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _placeholderImage();
        },
      );
    }
    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      height: 100,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
    );
  }
}