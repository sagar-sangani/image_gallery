import 'package:flutter/material.dart';
import 'package:image_gallery/ui/views/gallery/gallery_viewmodel.dart';
import 'package:stacked/stacked.dart';

class GalleryView extends StackedView<GalleryViewModel> {
  const GalleryView({super.key});

  @override
  GalleryViewModel viewModelBuilder(BuildContext context) => GalleryViewModel();

  @override
  void onViewModelReady(GalleryViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.fetchCuratedPhotos();
  }

  @override
  Widget builder(
    BuildContext context,
    GalleryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        // bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: viewModel.handleCollectionButtonTap,
                    child: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.folder,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: (viewModel.busy(viewModel.fetchCuratedPhotos) &&
                        viewModel.curatedPhotosPage == 1)
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : GridView.builder(
                        controller: viewModel.curatedPhotoListScrollController,
                        padding: EdgeInsets.all(0),
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2 / 3,
                        ),
                        itemCount: viewModel.curatedPhotos.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => viewModel.handlePhotoListItemTap(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: double.infinity,
                              child: Hero(
                                tag: '${viewModel.curatedPhotos[index]}',
                                child: Image.network(
                                  viewModel.curatedPhotos[index].src.portrait,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
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
