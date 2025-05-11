import 'package:flutter/material.dart';
import '../models/plant_model.dart';

class IdentifyDiagnoseScreen extends StatelessWidget {
  final Function(Plant, BuildContext) addPlantCallback;

  IdentifyDiagnoseScreen({super.key, required this.addPlantCallback});

  final List<Plant> _mockIdentifiablePlants = [
    Plant(id: '1', name: 'Samambaia Elegante', imagePath: 'assets/images/samambaia_elegante.jpg', careInstructions: 'Rega: 2-3x por semana. Luz: Indireta média.', commonProblems: 'Cochonilhas.'),
    Plant(id: '2', name: 'Suculenta Jade', imagePath: 'assets/images/suculenta_jade.png', careInstructions: 'Rega: Solo seco. Luz: Sol pleno.', commonProblems: 'Apodrecimento.'),
    Plant(id: '3', name: 'Orquídea Phalaenopsis', imagePath: 'assets/images/orquidea_phalaenopsis.jpg', careInstructions: 'Rega: 1x semana. Luz: Indireta brilhante.', commonProblems: 'Ácaros.'),
  ];

  Future<void> _showIdentificationDialog(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando: Abrir câmera/galeria...')),
    );
    await Future.delayed(const Duration(milliseconds: 500));

    showDialog<Plant>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Resultados da Identificação (Simulado)'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _mockIdentifiablePlants.length,
              itemBuilder: (context, index) {
                final plant = _mockIdentifiablePlants[index];
                return ListTile( // Início do ListTile
                  leading: Image.asset( // Image.asset é o leading
                    plant.imagePath,
                    width: 50,       // Parâmetro de Image.asset
                    height: 50,      // Parâmetro de Image.asset
                    fit: BoxFit.cover, // Parâmetro de Image.asset
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                  ), // Fim do Image.asset, que é o argumento para 'leading'
                  title: Text(plant.name),
                  subtitle: const Text('90% de confiança (simulado)'),
                  onTap: () {
                    Navigator.of(dialogContext).pop(plant);
                  },
                ); // Fim do ListTile
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    ).then((identifiedPlant) {
      if (identifiedPlant != null) {
        addPlantCallback(identifiedPlant, context);
      }
    });
  }

  Future<void> _showDiagnosisDialog(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando: Selecionar planta do jardim para diagnosticar...')),
    );
    await Future.delayed(const Duration(milliseconds: 500));

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Diagnóstico (Simulado)'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Planta: Samambaia Elegante (Exemplo)'),
              SizedBox(height: 8),
              Text('Problema: Fungo Oídio'),
              SizedBox(height: 8),
              Text('Tratamento Sugerido: Aplicar fungicida X e melhorar ventilação.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificar & Diagnosticar'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_enhance, size: 28),
                label: const Text('Identificar Planta por Foto', style: TextStyle(fontSize: 18)),
                onPressed: () => _showIdentificationDialog(context),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                icon: const Icon(Icons.healing_outlined, size: 28),
                label: const Text('Diagnosticar Problema', style: TextStyle(fontSize: 18)),
                onPressed: () => _showDiagnosisDialog(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Use a câmera para identificar plantas desconhecidas ou para obter um diagnóstico de problemas em suas plantas.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}