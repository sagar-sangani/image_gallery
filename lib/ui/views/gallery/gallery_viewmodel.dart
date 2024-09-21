import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_gallery/models/collection/collection.dart';
import 'package:image_gallery/models/photo/photo.dart';
import 'package:image_gallery/ui/views/collections/collections_view.dart';
import 'package:image_gallery/ui/views/image_details/image_details_view.dart';
import 'package:stacked/stacked.dart';

class GalleryViewModel extends BaseViewModel {
  List<Photo> curatedPhotos = [];
  List<Collection> collections = [];

  GalleryViewModel() {
    curatedPhotoListScrollController.addListener(handleScrollView);
  }

  Timer? _scrollDebounce;
  bool isScrollEventDispatched = false;
  ScrollController curatedPhotoListScrollController = ScrollController();
  void handleScrollView() {
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 50), () {
      if (curatedPhotoListScrollController.position.extentAfter <= 200) {
        if (!isScrollEventDispatched) {
          handleCuratedPhotoListScrollEnd();
          isScrollEventDispatched = true;
        }
      } else {
        isScrollEventDispatched = false;
      }
    });
  }

  int curatedPhotosPage = 1;

  Future<void> handleCuratedPhotoListScrollEnd() async {
    curatedPhotosPage++;
    await fetchCuratedPhotos(isPaginated: true);
  }

  Future<void> fetchCuratedPhotos({bool isPaginated = false}) async {
    setBusyForObject(fetchCuratedPhotos, true);
    try {
      final morePage = curatedPhotos.length % 20 == 0;

      if (!morePage && isPaginated) return;
      var response = await apiCuratedPhotoListV1(
        query: ApiCuratedPhotoListV1RequestQuery(page: curatedPhotosPage),
      );
      if (isPaginated) {
        curatedPhotos.addAll(response.photos);
      } else {
        curatedPhotos = response.photos;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      setBusyForObject(fetchCuratedPhotos, false);
    }
  }

  void handlePhotoListItemTap(int selectedImageIndex) {
    Get.to(
      () => ImageDetailsView(
        index: selectedImageIndex,
        curatedPhotos: curatedPhotos,
        currentPage: curatedPhotosPage,
        viewType: ViewType.gallery,
      ),
    );
  }

  void handleCollectionButtonTap() {
    Get.to(
      () => CollectionsView(),
      transition: Transition.circularReveal,
      duration: Duration(milliseconds: 800),
    );
  }

  bool get isInitialLoaderVisible =>
      busy(fetchCuratedPhotos) && curatedPhotosPage == 1;
}
