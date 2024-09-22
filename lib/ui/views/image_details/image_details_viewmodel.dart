import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_gallery/models/collection/collection.dart';
import 'package:image_gallery/models/enum.dart';
import 'package:image_gallery/models/photo/photo.dart';
import 'package:image_gallery/ui/utils/toast.dart';
import 'package:stacked/stacked.dart';

class ImageDetailsViewModel extends BaseViewModel {
  int index;
  List<Photo> images;
  int currentPage;
  PageController pageController = PageController(initialPage: 0);
  ViewType viewType;
  String? collectionId;

  ImageDetailsViewModel({
    required this.index,
    required this.images,
    required this.currentPage,
    required this.viewType,
    this.collectionId,
  }) {
    pageController = PageController(initialPage: index);
    pageController.addListener(handlePageChanged);
    photographer = images[index].photographer;
  }

  String photographer = 'Anonymous';

  Timer? _scrollDebounce;
  bool isScrollEventDispatched = false;

  void handleImageChanged(int index) {
    photographer = images[index].photographer;
    notifyListeners();
  }

  void handlePageChanged() {
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce?.cancel();

    _scrollDebounce = Timer(const Duration(milliseconds: 50), () {
      if (pageController.position.extentAfter <= 200) {
        if (!isScrollEventDispatched) {
          handleCuratedPhotoListScrollEnd();
          isScrollEventDispatched = true;
        }
      } else {
        isScrollEventDispatched = false;
      }
    });
  }

  Future<void> handleCuratedPhotoListScrollEnd() async {
    currentPage++;
    if (viewType == ViewType.gallery) {
      await fetchCuratedPhotos(isPaginated: true);
    } else {
      await getCollectionById(isPaginated: true);
    }
  }

  Future<void> fetchCuratedPhotos({bool isPaginated = false}) async {
    setBusyForObject(fetchCuratedPhotos, true);
    try {
      final morePage = images.length % 20 == 0;

      if (!morePage && isPaginated) return;
      var response = await apiCuratedPhotoListV1(
        query: ApiCuratedPhotoListV1RequestQuery(page: currentPage),
      );
      if (isPaginated) {
        images.addAll(response.photos);
      } else {
        images = response.photos;
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
      final morePage = images.length % 20 == 0;

      if (!morePage && isPaginated) return;
      if (collectionId == null) return;
      var response = await apiCollectionGetByIdV1(
        query: ApiCollectionGetByIdV1RequestQuery(page: currentPage),
        collectionId: collectionId!,
      );

      if (isPaginated) {
        images.addAll(response.media);
      } else {
        images = response.media;
      }
      notifyListeners();
    } catch (e) {
      showToast(text: e.toString());
    } finally {
      setBusyForObject(getCollectionById, false);
    }
  }
}
