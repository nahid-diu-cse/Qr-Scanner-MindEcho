import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_scanner_mindecho/view/home_qr_view/home_qr_view.dart';
import 'package:qr_scanner_mindecho/view/home_view/scan_from_gallery_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(ScanFromGalleryController());
  int currentTab = -1;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeQRView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    controller.pickAndScanImage();
                    currentTab = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.images,
                      color: currentTab == 0 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: currentTab == 0 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Container(),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    //currentScreen = const ScanFromGallery();
                    currentTab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.qrcode,
                      color: currentTab == 1 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Generate',
                      style: TextStyle(
                        color: currentTab == 1 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(FontAwesomeIcons.barcode),
        onPressed: () {
          setState(() {
            currentTab=-1;
            currentScreen = const HomeQRView();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
