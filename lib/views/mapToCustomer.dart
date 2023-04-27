import 'package:fastship_shipper/main.dart';
import 'package:fastship_shipper/utils/call_google_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapToCustomerPage extends StatelessWidget {
  const MapToCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map to customer'),
      ),
      body: MapToCustomerBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('open google map');
            MapUtils.openMap(10.8027996, 106.7416422);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.navigation)),
    );
  }
}

class MapToCustomerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Order(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
              onPressed: () {}, child: Text('Thanh toán số tiền còn lại')),
        ]),
        MapUiBody()
      ],
    );
  }
}

class MapUiBody extends StatefulWidget {
  const MapUiBody({super.key});

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(10.8027996, 106.7416422),
    zoom: 15.0,
  );

  bool _isMapCreated = false;

  final LatLng _markerPosition = const LatLng(10.8008, 106.7496354);
  late Position _currentPosition;

  late GoogleMapController _controller;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: true,
      mapToolbarEnabled: false,
      cameraTargetBounds: CameraTargetBounds.unbounded,
      minMaxZoomPreference: MinMaxZoomPreference.unbounded,
      mapType: MapType.normal,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      indoorViewEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      trafficEnabled: false,
      markers: <Marker>{_createMarker()},
      polylines: Set<Polyline>.of(polylines.values),
    );

    return Expanded(child: googleMap);
  }

  Marker _createMarker() {
    return Marker(
        markerId: const MarkerId('marker_1'), position: _markerPosition);
  }

  _createPolylines(
      double startLat, double startLong, double desLat, double desLong) async {
    var polylinePoints = PolylinePoints();

    List<LatLng> polylineCoords = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD6f3l7exbDwe2kzTmDO2o412q_etQtzt8',
      PointLatLng(startLat, startLong),
      PointLatLng(desLat, desLong),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoords, width: 3);

    setState(() {
      polylines[id] = polyline;
    });

    print('created polyline');
  }

  _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        print('position ');
        print(_currentPosition);

        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0)));
      });
    });

    _createPolylines(_currentPosition.latitude, _currentPosition.longitude,
        _markerPosition.latitude, _markerPosition.longitude);
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
    });

    _getCurrentLocation();
  }
}
