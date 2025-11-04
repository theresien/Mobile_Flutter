import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? AppTheme.primaryGradient
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [AppTheme.cardShadow],
          ),
          child: Text(
            category,
            style: GoogleFonts.plusJakartaSans(
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}