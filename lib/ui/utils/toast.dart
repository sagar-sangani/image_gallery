import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_corner/smooth_corner.dart';

Future<void> showToast({
  required String text,
}) {
  var controller = Get.rawSnackbar(
    messageText: _BaseToast(text: text),
    padding: EdgeInsets.only(top: 30, bottom: 40),
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 5),
    isDismissible: true,
    animationDuration: Duration(milliseconds: 800),
    reverseAnimationCurve: Curves.easeOut,
    snackPosition: SnackPosition.BOTTOM,
    dismissDirection: DismissDirection.horizontal,
  );

  return controller.future.then((value) async {
    await Future.delayed(const Duration(milliseconds: 200));
  });
}

class _BaseToast extends StatelessWidget {
  final String text;

  const _BaseToast({required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 18, right: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: ShapeDecoration(
              color: Colors.red.shade50,
              shape: SmoothRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                smoothness: 1.0,
                side: BorderSide(
                  width: 0.5,
                  color: Colors.red.shade600,
                ),
              ),
            ),
            child: IntrinsicHeight(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(right: 20, top: 5),
                        child: Icon(
                          Icons.error,
                          size: 16.0,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 10,
          child: GestureDetector(
            onTap: () {
              if (Get.isSnackbarOpen) Get.back();
            },
            child: Container(
              height: 20,
              width: 20,
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Colors.red.shade600,
                    width: 0.5,
                  ),
                  smoothness: 1.0,
                ),
                color: Colors.red.shade50,
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  size: 16.0,
                  color: Colors.red.shade600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
