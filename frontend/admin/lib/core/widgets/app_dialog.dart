import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDialog {
  // =======================
  // ERROR DIALOG
  // =======================
  static void showError(
    BuildContext context, {
    String title = "Terjadi Kesalahan",
    required String message,
  }) {
    _showBaseDialog(
      context,
      icon: Icons.error_outline_rounded,
      iconColor: Colors.red,
      title: title,
      message: message,
      buttonText: "OK",
    );
  }

  // =======================
  // SUCCESS DIALOG
  // =======================
  static void showSuccess(
    BuildContext context, {
    String title = "Berhasil",
    required String message,
  }) {
    _showBaseDialog(
      context,
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.green,
      title: title,
      message: message,
      buttonText: "OK",
    );
  }

  // =======================
  // CONFIRM DIALOG
  // =======================
  static Future<bool> showConfirm(
    BuildContext context, {
    String title = "Konfirmasi",
    required String message,
    String confirmText = "Ya",
    String cancelText = "Batal",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(message, style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // =======================
  // BASE DIALOG (PRIVATE)
  // =======================
  static void _showBaseDialog(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String buttonText,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return _BaseDialog(
          icon: icon,
          iconColor: iconColor,
          title: title,
          message: message,
          buttonText: buttonText,
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// =======================
// BASE UI WIDGET (PRIVATE)
// =======================
class _BaseDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonText;

  const _BaseDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: iconColor),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
