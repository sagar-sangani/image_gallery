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
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    splashColor: Colors.grey.shade300.withOpacity(0.1),
                    highlightColor: Colors.grey.shade100.withOpacity(0.1),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        Icons.folder,
                        size: 26,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: viewModel.isInitialLoaderVisible
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
