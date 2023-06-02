import 'package:fastship_shipper/models/product_issue.dart';
import 'package:fastship_shipper/providers/product_issue_provider.dart';
import 'package:fastship_shipper/services/goong_geocoding.dart';
import 'package:fastship_shipper/utils/call_google_map.dart';
import 'package:fastship_shipper/views/alert_dialogs.dart';
import 'package:fastship_shipper/views/product_issue_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:turf/src/geojson.dart' as geo_json;

class MapToCustomerForProductIssueWidget extends StatelessWidget {
  MapToCustomerForProductIssueWidget({super.key});

  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map to customer'),
      ),
      body: const MapToCustomerBodyForProductIssue(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var productIssueProvider =
                Provider.of<ProductIssueProvider>(context, listen: false);

            MapUtils.openMap(
                productIssueProvider.selectProductIssue.customerAddress);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.navigation)),
    );
  }
}

class MapToCustomerBodyForProductIssue extends StatelessWidget {
  const MapToCustomerBodyForProductIssue({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductIssueProvider>(
        builder: (context, productIssueProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductIssueWidget(
              productIssueModel: productIssueProvider.selectProductIssue,
              renderShippingButton: false),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                onPressed: () {
                  showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) =>
                              PaymentDialog.getConfirmDialog(context))
                      .then((isAcceptPayment) {
                    if (isAcceptPayment!) {
                      print('accept payment');

                      productIssueProvider.acceptPaymentAndFinish().then((_) {
                        productIssueProvider.getProductIssue();

                        showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    PaymentDialog.getSuccessDialog(context))
                            .then((_) {
                          Navigator.pop(context);
                        });
                      });
                    }
                  });
                },
                child: const Text('Thanh toán số tiền còn lại')),
          ]),
          const MapUiBody()
        ],
      );
    });
  }
}

class MapUiBody extends StatefulWidget {
  const MapUiBody({super.key});

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  MapboxMap? mapBoxMap;
  final getIt = GetIt.instance;

  late ProductIssueModel productIssueModel;

  late CircleAnnotationManager circleAnnotationManager;
  late PolylineAnnotationManager polylineAnnotationManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void moveCameraToDeviceLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    mapBoxMap?.flyTo(
        CameraOptions(
            center: Point(
                    coordinates: geo_json.Position(
                        position.longitude, position.latitude))
                .toJson(),
            zoom: 15.0),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

  Future<geo_json.Position> markCustomerLocationOnMap() async {
    var goongGeocoding = getIt.get<GoongGeocoding>();

    var json = await goongGeocoding
        .getPositionFromAddress(productIssueModel.customerAddress);

    double lat = json['results'][0]['geometry']['location']['lat'];
    double lng = json['results'][0]['geometry']['location']['lng'];

    circleAnnotationManager.create(CircleAnnotationOptions(
        geometry: Point(coordinates: geo_json.Position(lng, lat)).toJson(),
        circleColor: Colors.green.value,
        circleRadius: 12.0));

    return geo_json.Position(lng, lat);
  }

  void markDirectionToCustomer() async {
    var devicePosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    var customerPosition = await markCustomerLocationOnMap();

    var directionJson = await getIt.get<GoongGeocoding>().getDirection(
        devicePosition.latitude,
        devicePosition.longitude,
        customerPosition.lat as double,
        customerPosition.lng as double);

    List<dynamic> legsJson = directionJson['routes'][0]['legs'];

    for (dynamic leg in legsJson) {
      List<dynamic> stepsJson = leg['steps'];

      final listOfDirections = <List<geo_json.Position>>[];

      for (dynamic step in stepsJson) {
        print(step);
        print('\n');

        List<geo_json.Position> singleDirectionPositions = [];

        singleDirectionPositions.add(geo_json.Position(
            step['start_location']['lng'] as double,
            step['start_location']['lat'] as double));

        singleDirectionPositions.add(geo_json.Position(
            step['end_location']['lng'] as double,
            step['end_location']['lat'] as double));

        listOfDirections.add(singleDirectionPositions);
      }

      polylineAnnotationManager.createMulti(listOfDirections
          .map((e) => PolylineAnnotationOptions(
              geometry: LineString(coordinates: e).toJson(),
              lineWidth: 3.0,
              lineColor: Colors.blue.value))
          .toList());
    }
  }

  Future initAnnnotation() async {
    circleAnnotationManager =
        await mapBoxMap!.annotations.createCircleAnnotationManager();

    polylineAnnotationManager =
        await mapBoxMap!.annotations.createPolylineAnnotationManager();
  }

  onMapCreated(MapboxMap mapBoxMap) async {
    this.mapBoxMap = mapBoxMap;
    this.mapBoxMap!.location.updateSettings(
        LocationComponentSettings(enabled: true, pulsingEnabled: true));

    moveCameraToDeviceLocation();
    await initAnnnotation();

    markDirectionToCustomer();
  }

  @override
  Widget build(BuildContext context) {
    var map = MapWidget(
      onMapCreated: onMapCreated,
      resourceOptions: ResourceOptions(
          accessToken:
              'pk.eyJ1Ijoia2hhbmd6eHJyIiwiYSI6ImNsaDdqZDhzZzA4OHYzZ3VobWg0cnJpZmIifQ.jq1uF-z2DafPp2wpwZDwtg'),
    );

    return Consumer<ProductIssueProvider>(
        builder: (context, productIssueProvider, child) {
      productIssueModel = productIssueProvider.selectProductIssue;
      return Expanded(child: map);
    });
  }

  // _createPolylines(
  //     double startLat, double startLong, double desLat, double desLong) async {
  //   var polylinePoints = PolylinePoints();

  //   List<LatLng> polylineCoords = [];

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     'AIzaSyD6f3l7exbDwe2kzTmDO2o412q_etQtzt8',
  //     PointLatLng(startLat, startLong),
  //     PointLatLng(desLat, desLong),
  //   );

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoords.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   PolylineId id = PolylineId('poly');

  //   Polyline polyline = Polyline(
  //       polylineId: id, color: Colors.blue, points: polylineCoords, width: 3);

  //   setState(() {
  //     polylines[id] = polyline;
  //   });

  //   print('created polyline');
  // }

  // _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) async {
  //     setState(() {
  //       _currentPosition = position;

  //       print('position ');
  //       print(_currentPosition);

  //       _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //           target: LatLng(position.latitude, position.longitude),
  //           zoom: 18.0)));
  //     });
  //   });

  //   _createPolylines(_currentPosition.latitude, _currentPosition.longitude,
  //       _markerPosition.latitude, _markerPosition.longitude);
  // }
}
