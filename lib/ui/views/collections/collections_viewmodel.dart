import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_gallery/models/collection/collection.dart';
import 'package:image_gallery/ui/utils/toast.dart';
import 'package:image_gallery/ui/views/gallery/gallery_view.dart';
import 'package:stacked/stacked.dart';

class CollectionsViewModel extends BaseViewModel {
  CollectionsViewModel() {
    collectionListScrollController.addListener(handleScrollView);
  }
  List<Collection> collections = [];

  Timer? _scrollDebounce;
  bool isScrollEventDispatched = false;
  ScrollController collectionListScrollController = ScrollController();

  void handleScrollView() {
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 50), () {
      if (collectionListScrollController.position.extentAfter <= 400) {
        if (!isScrollEventDispatched) {
          handleCollectionListScrollEnd();
          isScrollEventDispatched = true;
        }
      } else {
        isScrollEventDispatched = false;
      }
    });
  }

  int collectionPage = 1;

  Future<void> handleCollectionListScrollEnd() async {
    collectionPage++;
    await getCollections(isPaginated: true);
  }

  Future<void> getCollections({bool isPaginated = false}) async {
    setBusyForObject(getCollections, true);
    try {
      final morePage = collections.length % 20 == 0;

      if (!morePage && isPaginated) return;
      var response = await apiFeaturedCollectionListV1(
        query: ApiFeaturedCollectionListV1RequestQuery(page: collectionPage),
      );

      if (isPaginated) {
        collections.addAll(response.collections);
      } else {
        collections = response.collections;
      }
      notifyListeners();
    } catch (e) {
      showToast(text: e.toString());
    } finally {
      setBusyForObject(getCollections, false);
    }
  }

  void handleCollectionListItemTap(Collection collection) {
    Get.to(() => GalleryView(collection: collection));
  }

  bool get isInitialLoaderVisible =>
      busy(getCollections) && collectionPage == 1;
}
