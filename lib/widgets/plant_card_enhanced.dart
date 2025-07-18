// lib/widgets/plant_card_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/plant_model.dart';

class PlantCardEnhanced extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const PlantCardEnhanced({
    super.key,
    required this.plant,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Imagem da planta
              Hero(
                tag: 'plant_image_${plant.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _buildPlantImage(),
                ),
              ),
              const SizedBox(width: 16),
              
              // Informações da planta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.careInstructions.split('.')[0],
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Status indicators
                    Row(
                      children: [
                        if (plant.diagnosis != null && plant.diagnosis!.isNotEmpty)
                          _buildStatusChip(
                            context,
                            'Precisa de cuidado',
                            CupertinoIcons.exclamationmark_triangle_fill,
                            Colors.orange,
                          ),
                        if (plant.reminderNote != null && plant.reminderNote!.isNotEmpty)
                          _buildStatusChip(
                            context,
                            'Com lembrete',
                            CupertinoIcons.bell_fill,
                            Theme.of(context).primaryColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Ações
              if (showActions)
                PopupMenuButton<String>(
                  icon: const Icon(CupertinoIcons.ellipsis_vertical),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.pencil),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.trash, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                )
              else
                const Icon(
                  CupertinoIcons.right_chevron,
                  color: Colors.grey,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    if (plant.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: plant.imageUrl!,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 70,
          height: 70,
          color: Colors.grey[200],
          child: const Icon(CupertinoIcons.leaf_arrow_circlepath, color: Colors.grey),
        ),
        errorWidget: (context, url, error) => Container(
          width: 70,
          height: 70,
          color: Colors.grey[200],
          child: const Icon(CupertinoIcons.leaf_arrow_circlepath, color: Colors.grey),
        ),
      );
    } else {
      return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          CupertinoIcons.leaf_arrow_circlepath,
          size: 32,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget _buildStatusChip(BuildContext context, String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}