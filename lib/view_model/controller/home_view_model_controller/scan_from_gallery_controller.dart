import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanFromGalleryController extends GetxController {
  RxString? qrCodeResult;
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _controller = MobileScannerController();

  Future<void> pickAndScanImage() async {
    try {
      // Pick an image from the gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // Decode the QR code from the image using MobileScanner
      final BarcodeCapture? capture =
          await _controller.analyzeImage(image.path);
      final Barcode? result =
          capture?.barcodes.isNotEmpty == true ? capture!.barcodes.first : null;
      qrCodeResult?.value =
          (result?.rawValue ?? "No QR code found in the image.");
    } catch (e) {
      qrCodeResult?.value = "Failed to scan QR code: $e";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
