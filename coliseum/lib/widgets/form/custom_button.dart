import 'package:coliseum/constants/theme.dart';
import 'package:flutter/material.dart';

enum CustomButtonVariant { primary, outline, text }
enum CustomButtonSize { medium, large }

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final Widget? leadingIcon;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.large,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _getStyle(theme);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }

  ButtonStyle _getStyle(ThemeData theme) {
    // Base padding and text style on size
    final double verticalPadding =
        size == CustomButtonSize.large ? 18.0 : 14.0;
    final TextStyle? textStyle = size == CustomButtonSize.large
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold);

    // Determine colors and shape based on variant
    switch (variant) {
      case CustomButtonVariant.outline:
        return ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.secondary,
          backgroundColor: Colors.transparent,
          side: BorderSide(color: theme.colorScheme.secondary, width: 1.5),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: textStyle,
        );
      case CustomButtonVariant.text:
         return ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.secondary,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: textStyle,
        );
      case CustomButtonVariant.primary:
      default:
        return ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.secondary,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
           textStyle: textStyle,
        );
    }
  }
} 