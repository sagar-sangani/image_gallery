import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery/ui/views/collections/collections_viewmodel.dart';
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
      body: SafeArea(
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
                      controller: viewModel.collectionListScrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: viewModel.collections.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => viewModel.handleCollectionListItemTap(
                            viewModel.collections[index]),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/folder_icon.svg",
                              height: 70,
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
  }
}
