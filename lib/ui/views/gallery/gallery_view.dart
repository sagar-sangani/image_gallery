import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/models/collection/collection.dart';
import 'package:image_gallery/services/connectivity_service.dart';
import 'package:image_gallery/ui/utils/image_utils.dart';
import 'package:image_gallery/ui/views/gallery/gallery_viewmodel.dart';
import 'package:image_gallery/ui/views/no_internet/no_internet_view.dart';
import 'package:stacked/stacked.dart';

class GalleryView extends StackedView<GalleryViewModel> {
  final Collection? collection;

  const GalleryView({
    super.key,
    this.collection,
  });

  @override
  GalleryViewModel viewModelBuilder(BuildContext context) =>
      GalleryViewModel(collection: collection);

  @override
  void onViewModelReady(GalleryViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.fetchImages();
  }

  @override
  Widget builder(
    BuildContext context,
    GalleryViewModel viewModel,
    Widget? child,
  ) {
    final connectivityController = Get.find<ConnectivityController>();

    return Obx(
      () {
        if (!connectivityController.isConnected.value) {
          return NoInternetView();
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black26,
            foregroundColor: Colors.white,
            automaticallyImplyLeading:
                !viewModel.isCollectionIconVisible ? true : false,
            centerTitle: false,
            title: Container(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                (collection != null) ? collection!.title : "Gallery",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            actions: [
              if (viewModel.isCollectionIconVisible)
                InkWell(
                  onTap: viewModel.handleCollectionButtonTap,
                  splashColor: Colors.grey.shade300.withOpacity(0.1),
                  highlightColor: Colors.grey.shade100.withOpacity(0.1),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(
                      Icons.folder,
                      size: 26,
                      color: Colors.blue,
                    ),
                  ),
                )
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: OrientationBuilder(
              builder: (context, orientation) {
                bool isPortraitMode = orientation == Orientation.portrait;
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: viewModel.isInitialLoaderVisible
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : GridView.builder(
                                controller:
                                    viewModel.galleryImageListScrollController,
                                padding: const EdgeInsets.only(top: 10),
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isPortraitMode ? 2 : 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio:
                                      isPortraitMode ? 2 / 3 : 3 / 2,
                                ),
                                itemCount: viewModel.galleryImages.length,
                                itemBuilder: (context, index) => Container(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () =>
                                        viewModel.handlePhotoListItemTap(index),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Hero(
                                          tag:
                                              '${viewModel.galleryImages[index]}',
                                          child: Image.network(
                                            viewModel.galleryImages[index].src
                                                .portrait,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                    loadingProgress) =>
                                                imageLoadingBuilder(context,
                                                    child, loadingProgress),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
