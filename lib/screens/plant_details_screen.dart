import 'package:flutter/material.dart';
import '../models/plant_model.dart';

class PlantDetailsScreen extends StatefulWidget {
  final Plant plant;
  final Function(Plant)? updateCallback; // Callback para atualizar a planta na lista de MainScreen

  const PlantDetailsScreen({
    super.key,
    required this.plant,
    this.updateCallback,
  });

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> with TickerProviderStateMixin { // Adicionar TickerProviderStateMixin
  late Plant _currentPlant;
  late TabController _tabController; // Para as abas Cuidados, Diário, Lembretes

  @override
  void initState() {
    super.initState();
    _currentPlant = widget.plant;
    _tabController = TabController(length: 3, vsync: this); // 3 abas
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<void> _simulateDiagnosis() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando captura de foto para diagnóstico...')),
    );
    await Future.delayed(const Duration(seconds: 1));

    final newDiagnosis = 'Manchas Foliares (simulado)';
    final newTreatment = 'Remover folhas afetadas. Aplicar spray antifúngico natural.';

    // Mostrar diálogo de confirmação antes de aplicar
    bool confirmUpdate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog( // Removido const daqui por causa do title
            title: const Text('Diagnóstico (Simulado)'), // Este pode ser const
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Problema Encontrado: $newDiagnosis'),
                const SizedBox(height: 8),
                Text('Tratamento Sugerido: $newTreatment'),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Salvar Diagnóstico')),
            ],
          ),
        ) ?? false;

    if (confirmUpdate) {
      setState(() {
        _currentPlant.diagnosis = newDiagnosis;
        _currentPlant.treatmentSuggestion = newTreatment;
      });
      widget.updateCallback?.call(_currentPlant); // Chama o callback para atualizar em MainScreen
      if (mounted) { // Verificar se o widget ainda está montado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnóstico salvo!')),
        );
      }
    }
  }

  Future<void> _setReminder() async {
    final reminderController = TextEditingController(text: _currentPlant.reminderNote);
    String? newReminder = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog( // Removido const daqui
        title: Text('Lembretes para ${_currentPlant.name}'), // CORRIGIDO: Removido 'const'
        content: TextField(
          controller: reminderController,
          decoration: const InputDecoration(hintText: 'Ex: Regar a cada 2 dias pela manhã'),
          autofocus: true,
          maxLines: null,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(reminderController.text);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    setState(() {
      _currentPlant.reminderNote = newReminder;
    });
    widget.updateCallback?.call(_currentPlant);
    if (mounted) { // Verificar se o widget ainda está montado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lembrete salvo!')),
      );
    }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPlant.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.eco_outlined), text: 'Cuidados'),
            Tab(icon: Icon(Icons.book_outlined), text: 'Diário'),
            Tab(icon: Icon(Icons.alarm_outlined), text: 'Lembretes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba Cuidados
          _buildCareTab(),
          // Aba Diário (Simulada)
          _buildDiaryTab(),
          // Aba Lembretes (Simulada)
          _buildRemindersTab(),
        ],
      ),
    );
  }

  Widget _buildCareTab() {
     return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: // Dentro de lib/screens/plant_details_screen.dart
// No método _buildCareTab()
// ...
Hero(
  tag: 'plant_image_${_currentPlant.id}',
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12.0),
    child: Image.asset( // <--- AQUI
      _currentPlant.imagePath,
      height: 220,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 220, color: Colors.grey),
    ),
  ),
),
// ...
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Cuidados Essenciais:'),
            Text(_currentPlant.careInstructions, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 20),
            _buildSectionTitle('Problemas Comuns:'),
            Text(_currentPlant.commonProblems, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 20),
            if (_currentPlant.diagnosis != null) ...[
              _buildSectionTitle('Último Diagnóstico:', color: Colors.orange.shade700),
              Text('Problema: ${_currentPlant.diagnosis}', style: const TextStyle(fontSize: 16)),
              Text('Sugestão: ${_currentPlant.treatmentSuggestion}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
             Center(
               child: ElevatedButton.icon(
                  icon: const Icon(Icons.healing_outlined),
                  label: const Text('Realizar Novo Diagnóstico'),
                  onPressed: _simulateDiagnosis,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                  ),
                ),
             ),
          ],
        ),
      );
  }

  Widget _buildDiaryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Diário de ${_currentPlant.name}'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: const [
                ListTile(leading: Icon(Icons.calendar_today), title: Text('20/Out: Adicionada ao jardim!'), subtitle: Text('Parece saudável.')),
                ListTile(leading: Icon(Icons.opacity), title: Text('22/Out: Primeira rega.'), subtitle: Text('Solo estava um pouco seco.')),
                ListTile(leading: Icon(Icons.camera_alt_outlined), title: Text('25/Out: Foto do progresso.'), subtitle: Text('Novas folhas surgindo!')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center( // Centralizar botão
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('Adicionar Entrada no Diário'),
              onPressed: () {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade de Diário (Não implementado)')),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

 Widget _buildRemindersTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Lembretes Ativos'),
          const SizedBox(height: 10),
          if (_currentPlant.reminderNote != null && _currentPlant.reminderNote!.isNotEmpty)
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.alarm, color: Colors.blue),
                title: const Text('Rega / Cuidados Gerais'),
                subtitle: Text(_currentPlant.reminderNote!),
                trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _setReminder),
              ),
            )
          else
            const Center(child: Text('Nenhum lembrete configurado para esta planta.')),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_alarm_outlined),
              label: Text(_currentPlant.reminderNote != null && _currentPlant.reminderNote!.isNotEmpty ? 'Editar Lembrete' : 'Adicionar Lembrete'),
              onPressed: _setReminder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    );
  }
}