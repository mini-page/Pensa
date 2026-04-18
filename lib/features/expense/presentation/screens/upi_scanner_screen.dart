import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

/// A QR scanner specialised for the "Pay Directly" flow.
///
/// Detects a UPI payment QR, extracts the full URI, and opens
/// [AddExpenseScreen] in pay-mode so the user can fill in the amount,
/// launch their UPI app, and then save the transaction.
class UpiScannerScreen extends StatefulWidget {
  const UpiScannerScreen({super.key});

  @override
  State<UpiScannerScreen> createState() => _UpiScannerScreenState();
}

class _UpiScannerScreenState extends State<UpiScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessed) return;
    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue != null) {
        _parseAndNavigate(rawValue);
        break;
      }
    }
  }

  void _parseAndNavigate(String rawValue) {
    if (!rawValue.startsWith('upi://pay')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not a UPI payment QR. Try again.')),
      );
      return;
    }

    setState(() => _isProcessed = true);

    final uri = Uri.parse(rawValue);
    final am = uri.queryParameters['am'];
    final pn = uri.queryParameters['pn'];
    final tn = uri.queryParameters['tn'];
    final amount = am != null ? double.tryParse(am) : null;
    // Prefer merchant name (pn) as pre-filled note, fall back to transaction note (tn).
    final note = pn?.isNotEmpty == true ? pn : tn;

    if (!mounted) return;

    AppRoutes.replaceWithPayExpense(
      context,
      payUpiUri: rawValue,
      initialAmount: amount,
      initialNote: note,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan UPI QR'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Point camera at a UPI payment QR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
