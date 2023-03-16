import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function selectPosition;

  const LocationInput(this.selectPosition, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';
  PlaceLocation? _currentLocation;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    final location = PlaceLocation(
      latitude: locData.latitude!,
      longitude: locData.longitude!,
    );

    _updateMapData(location);
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => _currentLocation == null
            ? const MapScreen()
            : MapScreen(initionLocation: _currentLocation!),
      ),
    );

    if (selectedLocation == null) return;

    final location = PlaceLocation(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );

    _updateMapData(location);
  }

  void _updateMapData(PlaceLocation location) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _currentLocation = location;
    });

    widget.selectPosition(
      LatLng(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          child: _previewImageUrl == ''
              ? const Text('Localização não informada')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: Text(
                'Localização atual',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: Text(
                'Selecione no Mapa',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
