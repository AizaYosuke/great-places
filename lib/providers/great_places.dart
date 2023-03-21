import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_util.dart';
import 'package:great_places/utils/location_util.dart';

class GreatPlaces with ChangeNotifier {
  final table = 'places';
  List<Place> _items = [];

  Future<void> loadPlaces() async {
    final dataList = await DBUtil.getData(table);
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();

    notifyListeners();
  }

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place getItem(int index) => _items[index];

  Future<void> addPlace(String title, File image, LatLng position) async {
    String address = await LocationUtil.getAdressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      image: image,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
    );

    _items.add(newPlace);

    DBUtil.insert(table, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    notifyListeners();
  }

  void removePlace(String title) {
    DBUtil.deleteData(table, title).then((value) {
      if (value == 1) {
        _items.removeWhere((element) => element.title == title);
        notifyListeners();
      }
    });
  }
}
