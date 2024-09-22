import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery/services/connectivity_service.dart';
import 'package:image_gallery/ui/views/collections/collections_viewmodel.dart';
import 'package:image_gallery/ui/views/no_internet/no_internet_view.dart';
import 'package:stacked/stacked.dart';

class CollectionsView extends StackedView<CollectionsViewModel> {
  const CollectionsView({super.key});

  @override
  CollectionsViewModel viewModelBuilder(BuildContext context) =>
      CollectionsViewModel();

  @override
  void onViewModelReady(CollectionsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getCollections();
  }

  @override
  Widget builder(
    BuildContext context,
    CollectionsViewModel viewModel,
    Widget? child,
  ) {
    final connectivityController = Get.find<ConnectivityController>();
    return Obx(
      () {
        if (!connectivityController.isConnected.value) {
          return NoInternetView();
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black26,
            foregroundColor: Colors.white,
            title: Text(
              "Collections",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            centerTitle: false,
          ),
          backgroundColor: Colors.black,
          body: OrientationBuilder(
            builder: (context, orientation) {
              bool isPortraitMode = orientation == Orientation.portrait;
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: viewModel.isInitialLoaderVisible
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : GridView.builder(
                                controller:
                                    viewModel.collectionListScrollController,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isPortraitMode ? 2 : 4,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.2,
                                ),
                                itemCount: viewModel.collections.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () =>
                                      viewModel.handleCollectionListItemTap(
                                          viewModel.collections[index]),
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/folder_icon.svg",
                                            height: 70,
                                          ),
                                          Positioned(
                                            top: 28,
                                            child: Text(
                                              viewModel.collections[index]
                                                  .photosCount
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 9, 68, 127),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        viewModel.collections[index].title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
