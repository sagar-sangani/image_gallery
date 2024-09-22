import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isConnected = true.obs;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _checkConnection();
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        isConnected.value = false;
      } else {
        isConnected.value = true;
      }
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _checkConnection() async {
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }
}
