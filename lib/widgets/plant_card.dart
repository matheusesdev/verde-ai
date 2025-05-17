// lib/widgets/plant_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/plant_model.dart'; // Modelo Plant já modificado

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const PlantCard({ super.key, required this.plant, required this.onTap });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (plant.imageUrl != null) {
      imageWidget = Image.network(
        plant.imageUrl!, width: 70, height: 70, fit: BoxFit.cover,
        errorBuilder: (c,e,s) => const Icon(CupertinoIcons.leaf_arrow_circlepath, size: 70, color: Colors.grey),
      );
    } else if (plant.imagePath != null) {
      imageWidget = Image.asset( // Assumindo que imagePath de dados mockados é sempre asset
        plant.imagePath!, width: 70, height: 70, fit: BoxFit.cover,
        errorBuilder: (c,e,s) => const Icon(CupertinoIcons.leaf_arrow_circlepath, size: 70, color: Colors.grey),
      );
    } else {
      imageWidget = const Icon(CupertinoIcons.leaf_arrow_circlepath, size: 70, color: Colors.grey);
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: [
              Hero(
                tag: 'plant_image_${plant.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: imageWidget,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plant.name, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(plant.careInstructions.split('.')[0], style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.right_chevron, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}