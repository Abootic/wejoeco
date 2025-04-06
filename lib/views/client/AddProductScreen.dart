import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../bloc/ProductBloc.dart';

import '../../repositories/SharedRepository.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';


class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0.0;
  String imageUrl = '';
  String? userId;
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      String? fetchedUserId = await _sharedRepository.getData("userId");
      if (!mounted) return;
      setState(() {
        userId = fetchedUserId;
      });
    } catch (e) {
      print("Error loading userId: $e");
    }
  }

  Future<String> _getBase64Image(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageUrl = image.path;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? base64Image;
      if (imageUrl.isNotEmpty) {
        base64Image = await _getBase64Image(imageUrl);
      }

      final productData = {
        'name': name,
        'price': price,
        'image': base64Image,
        'supplier_id': 1,
        'user_id': userId,
      };

      BlocProvider.of<ProductBloc>(context).add(SubmitProductData(model: productData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: AppStyles.inputDecoration('Product Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a product name' : null,
                  onSaved: (value) => name = value!,
                ),
                const SizedBox(height: AppStyles.padding),
                TextFormField(
                  decoration: AppStyles.inputDecoration('Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter a price' : null,
                  onSaved: (value) => price = double.parse(value!),
                ),
                const SizedBox(height: AppStyles.padding),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          imageUrl.isEmpty ? 'Select an Image' : 'Image Selected',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppStyles.padding),
                if (imageUrl.isNotEmpty)
                  Image.file(
                    File(imageUrl),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: AppStyles.padding),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: AppStyles.elevatedButtonStyle(AppColors.primary),
                  child: const Text('Add Product', style: TextStyle(color: AppColors.buttonText)),
                ),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state.currentState == StateTypes.submitting) {
                      return buildLoadingWidget();
                    }
                    if (state.currentState == StateTypes.submitted) {
                      return const Text('Product added successfully!');
                    }
                    if (state.currentState == StateTypes.error) {
                      return buildErrorWidget(state.error ?? "An error occurred.");
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}