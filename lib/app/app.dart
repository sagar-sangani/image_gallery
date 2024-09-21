import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/ui/views/home/home_view.dart';

class ImageGalleryApp extends StatelessWidget {
  const ImageGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Image Gallery',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
