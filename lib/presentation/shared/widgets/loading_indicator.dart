import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message!,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
