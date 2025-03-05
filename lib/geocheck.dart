import 'dart:async';
import 'dart:math' as math;

import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class GeoCheck {
  final GeolocatorPlatform _Geolocator = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubstatus;

  void toggleGeoListen() {
    log('_toggle');
    final positionStream = _Geolocator.getPositionStream();
    _positionStreamSubscription = positionStream.handleError((error) {
      log(error);
      _positionStreamSubscription?.cancel();
    }).listen(
      (position) {
        log(position.toString());
      },
    );

    _positionStreamSubscription?.pause();
  }

  void getPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("denied");
      }
    }
  }

  void toggleService() {
    final serviceStatusStream = _Geolocator.getServiceStatusStream();
    _serviceStatusStreamSubstatus = serviceStatusStream.handleError((error) {
      _serviceStatusStreamSubstatus?.cancel();
      log(error);
    }).listen((status) {
      log(status.toString());
      if (status == ServiceStatus.enabled) {
        toggleGeoListen();
      }
    });
  }

  bool getCurrentPosition() {
    bool isInCircle = false;
    _Geolocator.getCurrentPosition().then((item) {
      double multi = 1000000.0;
      double defaultLatitude = 37.569714 * multi;
      double defaultLongitude = 126.984186 * multi;
      num circle = math.pow(100.0, 2);
      isInCircle = (math.pow((item.latitude * multi) - defaultLatitude, 2) +
              math.pow((item.longitude * multi) - defaultLongitude, 2)) <=
          circle;
    });
    return isInCircle;
    // log(position.toString());
    // log(position.latitude.toString());
    // log(position.longitude.toString());
    // double multi = 1000000.0;
    // double defaultLatitude = 37.569714 * multi;
    // double defaultLongitude = 126.984186 * multi;
    // num circle = math.pow(100.0, 2);

    // bool isInCircle =
    //     (math.pow((position.latitude * multi) - defaultLatitude, 2) +
    //             math.pow((position.longitude * multi) - defaultLongitude, 2)) <=
    //         circle;
    // print((math.pow((position.latitude * multi) - defaultLatitude, 2) +
    //         math.pow((position.longitude * multi) - defaultLongitude, 2)) <=
    //     circle);
  }
}