import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../bloc/ProductBloc.dart';
import '../../models/ProductDTO.dart';
import '../../utilities/state_types.dart';
import 'Cart_Screen.dart';

class DashBoardContent extends StatefulWidget {
  const DashBoardContent({super.key});

  @override
  _DashBoardContentState createState() => _DashBoardContentState();
}

class _DashBoardContentState extends State<DashBoardContent> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.currentState == StateTypes.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.currentState == StateTypes.error) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state.data != null && state.data!.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
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
        return const Center(child: Text('No products available'));
      },
    );
  }

  Widget _buildProductItem(BuildContext context, ProductDTO product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProductImage(product.image),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: const Text('+ Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    const String baseUrl = 'http://127.0.0.1:8000/upload/products'; // Adjust for emulator
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final fullUrl = '$baseUrl/$imageUrl';
      print("Loading image from: $fullUrl");
      return Image.network(
        fullUrl,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Image load error: $error");
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