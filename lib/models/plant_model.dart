// lib/models/plant_model.dart
class Plant {
  final String id;
  final String name;
  final String? imageUrl; // Para URLs de rede (placeholders ou imagens de API)
  final String? imagePath; // Para caminhos de assets locais ou arquivos do dispositivo
  final String careInstructions;
  final String commonProblems;
  String? diagnosis;
  String? treatmentSuggestion;
  String? reminderNote;

  Plant({
    required this.id,
    required this.name,
    this.imageUrl,
    this.imagePath,
    required this.careInstructions,
    required this.commonProblems,
    this.diagnosis,
    this.treatmentSuggestion,
    this.reminderNote,
  }) : assert(imageUrl != null || imagePath != null, 'Ao menos imageUrl ou imagePath deve ser fornecido para a planta.');
}