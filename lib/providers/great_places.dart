import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  final List<Place> _items = [];

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place getItem(int index) => _items[index];

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: Random().toString(),
      title: title,
      image: image,
      // location: null,
    );

    _items.add(newPlace);
    notifyListeners();
  }
}
