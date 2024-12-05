import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner_mindecho/view_model/controller/home_view_model_controller/generate_qr_view_controller.dart';

class GenerateQrView extends StatefulWidget {
  const GenerateQrView({super.key});

  @override
  State<GenerateQrView> createState() => _GenerateQrViewState();
}

class _GenerateQrViewState extends State<GenerateQrView> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(GenerateQrViewController());

  final GlobalKey _qrKey = GlobalKey();

  // To control the visibility of the QR code
  bool _isQrVisible = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Generate QR",
          style: TextStyle(color: Colors.blueGrey),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade400,
        child: const Icon(FontAwesomeIcons.download),
        onPressed: () {},
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.qrTxtControler.value,
                    decoration: InputDecoration(
                        labelText: 'QR Text',
                        hintText: 'Enter text to generate QR',
                        filled: true,
                        fillColor: Colors.grey[50],
                        labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.textSlash,
                          color: Colors.blueGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Check if the text field is not empty
                      if (controller.qrTxtControler.value.text.isNotEmpty) {
                        setState(() {
                          _isQrVisible = true; // Make QR code visible
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orangeAccent.withOpacity(0.4),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: Colors.white, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Generate',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Conditionally display QR code
          if (_isQrVisible)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                width: width,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: RepaintBoundary(
                  key: _qrKey,
                  child: Obx(
                        () => QrImageView(
                      data: controller.qrTxtControler.value.text,
                      version: QrVersions.auto,
                      size: 300,
                      gapless: false,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
