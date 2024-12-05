import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeQRView extends StatefulWidget {
  const HomeQRView({super.key});

  @override
  State<HomeQRView> createState() => _HomeQRViewState();
}

class _HomeQRViewState extends State<HomeQRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isDialogShowing = false;
  // Prevent multiple dialogs

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.grey,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 5,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            top: height*.15,
            left: 0,
            right: 0,
            child: const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Scan the QR code here!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,// Optional: add background for readability
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isDialogShowing) {
        setState(() {
          result = scanData;
          isDialogShowing = true;
        });
        _showConfirmationDialog(scanData.code);
      }
    });
  }

  void _showConfirmationDialog(String? url) {
    if (url == null || url.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open URL'),
        content: Text('Do you want to open this URL?\n$url'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isDialogShowing = false;
              });
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isDialogShowing = false;
              });
              _launchURL(url);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
