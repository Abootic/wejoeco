// reusable_widgets.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

Widget buildErrorWidget(String errorMessage) {
  return Center(
    child: Card(
      color: AppColors.error.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Text(
          errorMessage,
          style: const TextStyle(color: AppColors.error, fontSize: 16),
        ),
      ),
    ),
  );
}

Widget buildLoadingWidget() {
  return const Center(
    child: CircularProgressIndicator(color: AppColors.primary),
  );
}