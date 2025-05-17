// lib/screens/identify_diagnose_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/plant_model.dart';

class IdentifyDiagnoseScreen extends StatelessWidget { // Mantido como StatelessWidget
  final Function(Plant, BuildContext) addPlantCallback;

  IdentifyDiagnoseScreen({super.key, required this.addPlantCallback});

  // Dados mock com imageUrl para placeholders
  final List<Plant> _mockIdentifiablePlants = [
    Plant(id: '1', name: 'Samambaia Elegante', imageUrl: 'https://via.placeholder.com/150/92C952/FFFFFF?Text=Samambaia', careInstructions: 'Rega: 2-3x por semana. Luz: Indireta média.', commonProblems: 'Cochonilhas.'),
    Plant(id: '2', name: 'Suculenta Jade', imageUrl: 'https://via.placeholder.com/150/2ECC71/FFFFFF?Text=Suculenta', careInstructions: 'Rega: Solo seco. Luz: Sol pleno.', commonProblems: 'Apodrecimento.'),
    Plant(id: '3', name: 'Orquídea Phalaenopsis', imageUrl: 'https://via.placeholder.com/150/8E44AD/FFFFFF?Text=Orquidea', careInstructions: 'Rega: 1x semana. Luz: Indireta brilhante.', commonProblems: 'Ácaros.'),
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
                return ListTile(
                  leading: plant.imageUrl != null ?
                    Image.network(plant.imageUrl!, width: 50, height: 50, fit: BoxFit.cover,
                      errorBuilder: (c,e,s) => const Icon(CupertinoIcons.photo, size: 50),
                    ) : const Icon(CupertinoIcons.photo, size: 50),
                  title: Text(plant.name),
                  subtitle: const Text('90% de confiança (simulado)'),
                  onTap: () {
                    Navigator.of(dialogContext).pop(plant);
                  },
                );
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
    // ... (lógica do _showDiagnosisDialog como antes) ...
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
              SizedBox(height: 8), Text('Problema: Fungo Oídio'),
              SizedBox(height: 8), Text('Tratamento Sugerido: Aplicar fungicida X e melhorar ventilação.'),
            ],
          ),
          actions: <Widget>[ TextButton(child: const Text('OK'), onPressed: () => Navigator.of(dialogContext).pop()) ],
        );
      },
    );
  }

  // MÉTODO BUILD IMPLEMENTADO
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
                icon: const Icon(CupertinoIcons.camera_viewfinder, size: 28),
                label: const Text('Identificar Planta por Foto', style: TextStyle(fontSize: 18)),
                onPressed: () => _showIdentificationDialog(context),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.bandage, size: 28), // Ícone Cupertino
                label: const Text('Diagnosticar Problema', style: TextStyle(fontSize: 18)),
                onPressed: () => _showDiagnosisDialog(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  foregroundColor: Theme.of(context).primaryColor, // Cor do texto/ícone
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Use a câmera para identificar plantas desconhecidas ou para obter um diagnóstico de problemas em suas plantas.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}