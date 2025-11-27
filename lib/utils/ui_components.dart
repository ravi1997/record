import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/theme_constants.dart';

// Reusable UI Components
class UIComponents {
  // Reusable Stat Card Widget - Material 3 style
  static Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: ThemeConstants.lightColorScheme.surfaceContainerLow,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Reusable Action Card Widget - Material 3 style
  static Widget buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: ThemeConstants.lightColorScheme.surfaceContainerLow,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Time Range Button
  static Widget buildTimeRangeButton({
    required String label,
    required int index,
    required int selectedTimeRange,
    required Function(int) onSelect,
  }) {
    bool isSelected = selectedTimeRange == index;
    return Expanded(
      child: TextButton(
        onPressed: () {
          onSelect(index);
        },
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? ThemeConstants.lightColorScheme.primary
              : Colors.transparent,
          foregroundColor: isSelected
              ? ThemeConstants.lightColorScheme.onPrimary
              : ThemeConstants.lightColorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isSelected
                  ? ThemeConstants.lightColorScheme.primary
                  : ThemeConstants.lightColorScheme.outlineVariant,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Reusable Input Field
  static Widget buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      style: TextStyle(color: ThemeConstants.lightColorScheme.onSurface),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon,
            color: ThemeConstants.lightColorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: ThemeConstants.lightColorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: ThemeConstants.lightColorScheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Reusable Button
  static Widget buildButton({
    required String text,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ThemeConstants.elevatedButtonStyle.copyWith(
                backgroundColor: backgroundColor != null
                    ? WidgetStateProperty.all(backgroundColor)
                    : null,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? ThemeConstants.lightColorScheme.onPrimary,
                  fontSize: AppConstants.regularTextSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // Reusable SnackBar
  static SnackBar buildSnackBar({
    required String message,
    required Color backgroundColor,
    IconData? icon,
  }) {
    return SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon,
                color: ThemeConstants.lightColorScheme.onPrimaryContainer),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: ThemeConstants.lightColorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ThemeConstants.lightColorScheme.primaryContainer,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: ThemeConstants.lightColorScheme.outlineVariant),
      ),
      elevation: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Reusable AppBar
  static AppBar buildAppBar({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: ThemeConstants.lightColorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor:
          backgroundColor ?? ThemeConstants.lightColorScheme.surface,
      foregroundColor:
          foregroundColor ?? ThemeConstants.lightColorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 3,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withAlpha(13),
      centerTitle: true,
      actions: actions,
    );
  }

  // Reusable Info Chip
  static Widget buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}