import 'package:flutter/material.dart';
import '../models/plant_model.dart'; // Importar o modelo Plant
import '../widgets/plant_card.dart';
// Não precisamos importar PlantDetailsScreen aqui se a navegação é via pushNamed
// e onGenerateRoute em main.dart cuida da construção da tela.

class MyGardenScreen extends StatelessWidget {
  final List<Plant> myPlants;
  final Function(Plant, BuildContext) addPlantCallback; // Assumindo que este é o tipo correto
  final Function(Plant) updatePlantCallback;

  const MyGardenScreen({
    super.key,
    required this.myPlants,
    required this.addPlantCallback, // Certifique-se que este callback é o correto vindo de MainScreen
    required this.updatePlantCallback,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Jardim'),
        automaticallyImplyLeading: false,
      ),
      body: myPlants.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Seu jardim está vazio.\nUse a aba "Identificar" para adicionar sua primeira planta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: myPlants.length,
              itemBuilder: (ctx, index) {
                final plant = myPlants[index]; // Pegar a planta atual
                return PlantCard(
                  plant: plant,
                  onTap: () {
                    // CORRIGIDO: Usar Navigator.pushNamed e passar argumentos como Map
                    Navigator.pushNamed(
                      context,
                      '/plant_details',
                      arguments: {
                        'plant': plant, // Passar o objeto Plant
                        'updateCallback': updatePlantCallback, // Passar a função de callback
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}