import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/models/enum.dart';
import 'package:image_gallery/models/photo/photo.dart';
import 'package:image_gallery/services/connectivity_service.dart';
import 'package:image_gallery/ui/utils/image_utils.dart';
import 'package:image_gallery/ui/views/no_internet/no_internet_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:stacked/stacked.dart';

import 'image_details_viewmodel.dart';

class ImageDetailsView extends StackedView<ImageDetailsViewModel> {
  final List<Photo> curatedPhotos;
  final int index;
  final int currentPage;
  final ViewType viewType;
  final String? collectionId;

  ImageDetailsView({
    super.key,
    required this.curatedPhotos,
    required this.index,
    required this.currentPage,
    required this.viewType,
    this.collectionId,
  });

  @override
  ImageDetailsViewModel viewModelBuilder(BuildContext context) =>
      ImageDetailsViewModel(
        index: index,
        images: curatedPhotos,
        currentPage: currentPage,
        viewType: viewType,
        collectionId: collectionId,
      );

  @override
  Widget builder(
    BuildContext context,
    ImageDetailsViewModel viewModel,
    Widget? child,
  ) {
    final connectivityController = Get.find<ConnectivityController>();

    return Obx(
      () {
        if (!connectivityController.isConnected.value) {
          return NoInternetView();
        }
        return Scaffold(
          backgroundColor: Colors.black26,
          appBar: AppBar(
            backgroundColor: Colors.black26,
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo Clicked By',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  viewModel.photographer,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PhotoViewGallery.builder(
                    backgroundDecoration: BoxDecoration(color: Colors.black),
                    itemCount: viewModel.images.length,
                    onPageChanged: (index) =>
                        viewModel.handleImageChanged(index),
                    builder: (context, index) =>
                        PhotoViewGalleryPageOptions.customChild(
                      child: Hero(
                        tag: '${viewModel.images[index]}',
                        child: Image.network(
                          viewModel.images[index].src.portrait,
                          loadingBuilder: (context, child, loadingProgress) =>
                              imageLoadingBuilder(
                                  context, child, loadingProgress),
                        ),
                      ),
                      minScale: PhotoViewComputedScale.contained,
                    ),
                    pageController: viewModel.pageController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
