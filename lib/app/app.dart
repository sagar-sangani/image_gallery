import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/services/connectivity_service.dart';
import 'package:image_gallery/ui/views/gallery/gallery_view.dart';

class ImageGalleryApp extends StatelessWidget {
  const ImageGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(fontFamily: 'Metropolis'),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(ConnectivityController());
      }),
      home: const GalleryView(),
    );
  }
}
