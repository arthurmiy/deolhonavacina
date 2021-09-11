import 'package:deolhonafila/classes/converter.dart';
import 'package:deolhonafila/classes/posto.dart';
import 'package:deolhonafila/interface/widgets/data_show.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapView extends StatefulWidget {
  static final String route = '/map';
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Posto? posto;
  LocationData? locationInfos;
  late final MapController _mapController;

  void internalCallback(Posto value) {
    setState(() {
      this.posto = value == this.posto ? null : value;
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    posto = null;
    callbackIcon = internalCallback;
    getLocation();
  }

  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    locationInfos = null;
    if (_mapController != null && _locationData.latitude != null) {
      _mapController.move(
          LatLng(_locationData.latitude!, _locationData.longitude!),
          _mapController.zoom);

      setState(() {
        locationInfos = _locationData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          // do something when scrolled
          _mapController.move(
              LatLng(_mapController.center.latitude,
                  _mapController.center.longitude),
              _mapController.zoom - pointerSignal.scrollDelta.dy / 1000);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(-23.55111018131189, -46.63432433511864),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: markersList,
                ),
                MarkerLayerOptions(
                    markers: locationInfos == null
                        ? []
                        : [
                            Marker(
                                width: 60.0,
                                height: 60.0,
                                point: LatLng(locationInfos!.latitude!,
                                    locationInfos!.longitude!),
                                builder: (ctx) => Container(
                                        child: Icon(
                                      Icons.person_pin_circle,
                                      size: 40,
                                    ))),
                          ]),
              ],
            ),
            this.posto == null
                ? Container()
                : Container(
                    color: Colors.white,
                    constraints: BoxConstraints(maxWidth: 500),
                    child: DataShow(
                      posto: this.posto,
                      onClose: () {
                        this.posto = null;
                        setState(() {});
                      },
                      onMap: () async {
                        LatLon tmp =
                            converter[this.posto!.name] ?? LatLon(0.0, 0.0);
                        MapsLauncher.launchCoordinates(tmp.lat, tmp.lon);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
