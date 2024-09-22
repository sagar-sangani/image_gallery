import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_gallery/models/collection/collection.dart';
import 'package:image_gallery/models/enum.dart';
import 'package:image_gallery/models/photo/photo.dart';
import 'package:image_gallery/ui/utils/toast.dart';
import 'package:image_gallery/ui/views/collections/collections_view.dart';
import 'package:image_gallery/ui/views/image_details/image_details_view.dart';
import 'package:stacked/stacked.dart';

class GalleryViewModel extends BaseViewModel {
  Collection? collection;

  GalleryViewModel({this.collection}) {
    galleryImageListScrollController.addListener(handleScrollView);
  }

  List<Photo> galleryImages = [];
  ScrollController galleryImageListScrollController = ScrollController();

  Timer? _scrollDebounce;
  bool isScrollEventDispatched = false;
  void handleScrollView() {
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 50), () {
      if (galleryImageListScrollController.position.extentAfter <= 400) {
        if (!isScrollEventDispatched) {
          handleGalleryImageListScrollEnd();
          isScrollEventDispatched = true;
        }
      } else {
        isScrollEventDispatched = false;
      }
    });
  }

  int galleryImagesPage = 1;

  Future<void> handleGalleryImageListScrollEnd() async {
    galleryImagesPage++;
    if (collection != null) {
      await getCollectionById(isPaginated: true);
    } else {
      await fetchCuratedPhotos(isPaginated: true);
    }
  }

  Future<void> fetchCuratedPhotos({bool isPaginated = false}) async {
    setBusyForObject(fetchCuratedPhotos, true);
    try {
      final morePage = galleryImages.length % 20 == 0;

      if (!morePage && isPaginated) return;
      var response = await apiCuratedPhotoListV1(
        query: ApiCuratedPhotoListV1RequestQuery(page: galleryImagesPage),
      );
      if (isPaginated) {
        galleryImages.addAll(response.photos);
      } else {
        galleryImages = response.photos;
      }
      notifyListeners();
    } catch (e) {
      showToast(text: e.toString());
    } finally {
      setBusyForObject(fetchCuratedPhotos, false);
    }
  }

  Future<void> getCollectionById({bool isPaginated = false}) async {
    setBusyForObject(getCollectionById, true);
    try {
      final morePage = galleryImages.length % 20 == 0;

      if (!morePage && isPaginated) return;
      var response = await apiCollectionGetByIdV1(
        query: ApiCollectionGetByIdV1RequestQuery(page: galleryImagesPage),
        collectionId: collection!.id,
      );

      if (isPaginated) {
        galleryImages.addAll(response.media);
      } else {
        galleryImages = response.media;
      }
      notifyListeners();
    } catch (e) {
      showToast(text: e.toString());
    } finally {
      setBusyForObject(getCollectionById, false);
    }
  }

  void handlePhotoListItemTap(int selectedImageIndex) {
    Get.to(
      () => ImageDetailsView(
        index: selectedImageIndex,
        curatedPhotos: galleryImages,
        currentPage: galleryImagesPage,
        viewType: ViewType.gallery,
      ),
    );
  }

  void handleCollectionButtonTap() {
    Get.to(
      () => const CollectionsView(),
      transition: Transition.topLevel,
      duration: const Duration(milliseconds: 800),
    );
  }

  void fetchImages() {
    if (collection != null) {
      getCollectionById();
    } else {
      fetchCuratedPhotos();
    }
  }

  bool get isInitialLoaderVisible =>
      ((busy(fetchCuratedPhotos) || busy(getCollectionById)) &&
          galleryImagesPage == 1);

  bool get isCollectionIconVisible => collection == null;
}
