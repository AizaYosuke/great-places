import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Lugares'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PLACE_FORM,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<GreatPlaces>(
                    child: const Center(
                      child: Text('Nenhum local cadastrado.'),
                    ),
                    builder: (ctx, greatPlaces, child) =>
                        greatPlaces.itemsCount == 0
                            ? child!
                            : ListView.builder(
                                itemCount: greatPlaces.itemsCount,
                                itemBuilder: (ctx, i) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        FileImage(greatPlaces.items[i].image),
                                  ),
                                  title: Text(greatPlaces.items[i].title),
                                  onTap: () {},
                                  trailing: IconButton(
                                      onPressed: () {
                                        greatPlaces.removePlace(
                                            greatPlaces.items[i].title);
                                      },
                                      icon: Icon(Icons.delete)),
                                ),
                              ),
                  ),
      ),
    );
  }
}
