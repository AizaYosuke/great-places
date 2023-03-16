import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initionLocation;
  final bool isReadOnly;

  const MapScreen({
    super.key,
    this.initionLocation = const PlaceLocation(
      latitude: 37.422131,
      longitude: -122.084801,
    ),
    this.isReadOnly = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione...'),
        actions: [
          if(!widget.isReadOnly)
          IconButton(
            onPressed: () {
              if (_pickedPosition == null) return;

              Navigator.of(context).pop(_pickedPosition);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initionLocation.latitude,
            widget.initionLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? (_) {} : _selectPosition,
        markers: _pickedPosition == null
            ? <Marker>{}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position: _pickedPosition!,
                ),
              },
      ),
    );
  }
}
