import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_util.dart';

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
          ),
        )
        .toList();

    notifyListeners();
  }

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place getItem(int index) => _items[index];

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      image: image,
      // location: null,
    );

    _items.add(newPlace);

    DBUtil.insert(table, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
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
