// lib/screens/my_garden_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_card_enhanced.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../models/plant_model.dart'; // Importar o modelo Plant

class MyGardenScreen extends StatefulWidget {
  final Function(Plant, BuildContext) addPlantCallback;
  final Function(Plant) updatePlantCallback;

  const MyGardenScreen({
    super.key,
    required this.addPlantCallback,
    required this.updatePlantCallback,
  });

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantProvider>(
      builder: (context, plantProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: _isSearching 
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Buscar plantas...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      plantProvider.searchPlants(value);
                    },
                  )
                : Text('Meu Jardim (${plantProvider.plantsCount})'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(_isSearching ? CupertinoIcons.clear : CupertinoIcons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchController.clear();
                      plantProvider.clearSearch();
                    } else {
                      _isSearching = true;
                    }
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(CupertinoIcons.ellipsis_vertical),
                onSelected: (value) {
                  switch (value) {
                    case 'sort_name':
                      // Implementar ordenação por nome
                      break;
                    case 'sort_date':
                      // Implementar ordenação por data
                      break;
                    case 'refresh':
                      plantProvider.loadPlants();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'sort_name',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.sort_up),
                        SizedBox(width: 8),
                        Text('Ordenar por Nome'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'sort_date',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.calendar),
                        SizedBox(width: 8),
                        Text('Ordenar por Data'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.refresh),
                        SizedBox(width: 8),
                        Text('Atualizar'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: _buildBody(plantProvider),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navegar para tela de identificação
              DefaultTabController.of(context)?.animateTo(2);
            },
            child: const Icon(CupertinoIcons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(PlantProvider plantProvider) {
    if (plantProvider.isLoading) {
      return const LoadingWidget(message: 'Carregando suas plantas...');
    }

    if (plantProvider.error != null) {
      return CustomErrorWidget(
        message: plantProvider.error!,
        onRetry: () {
          plantProvider.clearError();
          plantProvider.loadPlants();
        },
      );
    }

    final plants = plantProvider.plants;

    if (plants.isEmpty) {
      if (plantProvider.searchQuery.isNotEmpty) {
        return EmptyStateWidget(
          title: 'Nenhuma planta encontrada',
          message: 'Não encontramos plantas com "${plantProvider.searchQuery}".\nTente buscar por outro termo.',
          icon: CupertinoIcons.search,
          actionText: 'Limpar Busca',
          onAction: () {
            _searchController.clear();
            plantProvider.clearSearch();
            setState(() {
              _isSearching = false;
            });
          },
        );
      } else {
        return EmptyStateWidget(
          title: 'Seu jardim está vazio',
          message: 'Que tal adicionar sua primeira planta?\nUse a aba "Identificar" para começar!',
          icon: CupertinoIcons.tree,
          actionText: 'Identificar Planta',
          onAction: () {
            DefaultTabController.of(context)?.animateTo(2);
          },
        );
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        await plantProvider.loadPlants();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: plants.length,
        itemBuilder: (ctx, index) {
          final plant = plants[index];
          return PlantCardEnhanced(
            plant: plant,
            showActions: true,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/plant_details',
                arguments: {
                  'plant': plant,
                  'updateCallback': widget.updatePlantCallback,
                },
              );
            },
            onEdit: () {
              _showEditPlantDialog(plant);
            },
            onDelete: () {
              _showDeleteConfirmation(plant);
            },
          );
        },
      ),
    );
  }

  void _showEditPlantDialog(Plant plant) {
    final nameController = TextEditingController(text: plant.name);
    final careController = TextEditingController(text: plant.careInstructions);
    final problemsController = TextEditingController(text: plant.commonProblems);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Planta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Planta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: careController,
                decoration: const InputDecoration(
                  labelText: 'Instruções de Cuidado',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: problemsController,
                decoration: const InputDecoration(
                  labelText: 'Problemas Comuns',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final updatedPlant = Plant(
                  id: plant.id,
                  name: nameController.text.trim(),
                  imageUrl: plant.imageUrl,
                  imagePath: plant.imagePath,
                  careInstructions: careController.text.trim(),
                  commonProblems: problemsController.text.trim(),
                  diagnosis: plant.diagnosis,
                  treatmentSuggestion: plant.treatmentSuggestion,
                  reminderNote: plant.reminderNote,
                );
                
                Provider.of<PlantProvider>(context, listen: false)
                    .updatePlant(updatedPlant);
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Plant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Planta'),
        content: Text('Tem certeza que deseja excluir "${plant.name}"?\nEsta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<PlantProvider>(context, listen: false)
                  .deletePlant(plant.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${plant.name} foi excluída')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}