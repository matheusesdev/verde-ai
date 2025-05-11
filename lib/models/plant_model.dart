class Plant {
  final String id;
  final String name;
  final String imagePath; // Campo crucial para imagens locais
  final String careInstructions;
  final String commonProblems;
  String? diagnosis;
  String? treatmentSuggestion;
  String? reminderNote;

  Plant({
    required this.id,
    required this.name,
    required this.imagePath, // Incluído no construtor
    required this.careInstructions,
    required this.commonProblems,
    this.diagnosis,
    this.treatmentSuggestion,
    this.reminderNote,
  });
}