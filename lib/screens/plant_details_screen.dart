// lib/screens/plant_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/plant_model.dart';
// Se você usar DateFormat em algum lugar aqui (ex: no diário), importe intl
// import 'package:intl/intl.dart';

// A classe Article deve estar em article_details_screen.dart ou em seu próprio arquivo de modelo
// Se esta tela for SÓ para Plantas, você não precisa do modelo Article aqui.
// Assumindo que esta tela é APENAS para Plantas, como o nome sugere.

class PlantDetailsScreen extends StatefulWidget {
  final Plant plant;
  final Function(Plant)? updateCallback;

  const PlantDetailsScreen({
    super.key,
    required this.plant,
    this.updateCallback,
  });

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> with TickerProviderStateMixin {
  late Plant _currentPlantData; // Usar uma cópia para modificações locais se necessário
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentPlantData = widget.plant; // Inicializar com os dados da planta passada
    _tabController = TabController(length: 3, vsync: this);
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

    bool confirmUpdate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Diagnóstico (Simulado)'),
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
        _currentPlantData.diagnosis = newDiagnosis;
        _currentPlantData.treatmentSuggestion = newTreatment;
      });
      widget.updateCallback?.call(_currentPlantData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnóstico salvo!')),
        );
      }
    }
  }

  Future<void> _setReminder() async {
    final reminderController = TextEditingController(text: _currentPlantData.reminderNote);
    String? newReminder = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lembretes para ${_currentPlantData.name}'),
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

    if (newReminder != null) {
      setState(() {
        _currentPlantData.reminderNote = newReminder;
      });
      widget.updateCallback?.call(_currentPlantData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lembrete salvo!')),
        );
      }
    }
  }

  Widget _buildHeroImage() {
    Widget imageContent;
    if (_currentPlantData.imageUrl != null) {
      imageContent = Image.network(
        _currentPlantData.imageUrl!, fit: BoxFit.cover,
        errorBuilder: (c,e,s) => Container(color: Colors.grey[300], child: const Icon(CupertinoIcons.photo, size: 100, color: Colors.grey)),
      );
    } else if (_currentPlantData.imagePath != null) {
      imageContent = Image.asset( // Assumindo que imagePath aqui seja para assets
        _currentPlantData.imagePath!, fit: BoxFit.cover,
        errorBuilder: (c,e,s) => Container(color: Colors.grey[300], child: const Icon(CupertinoIcons.photo, size: 100, color: Colors.grey)),
      );
    } else { // Fallback se nenhum caminho de imagem for fornecido
      imageContent = Container(color: Colors.grey[300], child: const Icon(CupertinoIcons.photo, size: 100, color: Colors.grey));
    }

    return Hero(
      tag: 'plant_image_${_currentPlantData.id}', // Usar o id da planta atual
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageContent,
          const DecoratedBox( // Gradiente
            decoration: BoxDecoration( // 'decoration' é obrigatório para DecoratedBox
              gradient: LinearGradient(
                begin: Alignment(0.0, 0.6),
                end: Alignment.bottomCenter,
                colors: <Color>[ Colors.transparent, Colors.black87 ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
    final bool isDarkMode = platformBrightness == Brightness.dark;
    final Color appBarIconColor = isDarkMode ? CupertinoColors.white : CupertinoColors.black;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false, pinned: true, stretch: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.back, color: appBarIconColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16, end: 56),
              title: Text(
                _currentPlantData.name, // Usar o nome da planta atual
                style: TextStyle(fontSize: 17.0, color: appBarIconColor, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              background: _buildHeroImage(), // Usar a função helper
            ),
            actions: [
               CupertinoButton(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(CupertinoIcons.share, color: appBarIconColor),
                onPressed: () { /* Lógica de compartilhar planta */ },
              ),
            ],
          ),
          SliverPadding( // SliverPadding requer 'padding' e 'sliver'
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Conteúdo das abas será renderizado aqui
                  // Por simplicidade, vamos colocar um placeholder por enquanto
                  // Você integrará _buildCareTab, _buildDiaryTab, _buildRemindersTab
                  // usando o _tabController
                  // Exemplo:
                  // TabBarView(controller: _tabController, children: [_buildCareTab(), ...])
                  // Mas isso não funciona bem dentro de SliverList.
                  // Uma abordagem comum é ter o TabBar na SliverAppBar
                  // e o TabBarView como o corpo principal do Scaffold,
                  // ou construir a UI das abas condicionalmente aqui.

                  // Para este exemplo, vamos apenas mostrar os cuidados:
                  _buildSectionTitle(context, 'Cuidados Essenciais:'),
                  SelectableText(_currentPlantData.careInstructions, style: textTheme.bodyLarge?.copyWith(height: 1.75, fontSize: 17)),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle(context, 'Problemas Comuns:'),
                  SelectableText(_currentPlantData.commonProblems, style: textTheme.bodyLarge?.copyWith(height: 1.75, fontSize: 17)),

                  if (_currentPlantData.diagnosis != null) ...[
                    const SizedBox(height: 20.0),
                    _buildSectionTitle(context, 'Último Diagnóstico:', color: Colors.orange.shade700),
                    Text('Problema: ${_currentPlantData.diagnosis}', style: textTheme.bodyLarge),
                    Text('Sugestão: ${_currentPlantData.treatmentSuggestion}', style: textTheme.bodyLarge),
                  ],

                  const SizedBox(height: 20.0),
                  Center(child: ElevatedButton.icon(onPressed: _simulateDiagnosis, icon: const Icon(Icons.healing_outlined), label: const Text("Diagnosticar Problema"))),
                  const SizedBox(height: 10.0),
                  Center(child: ElevatedButton.icon(onPressed: _setReminder, icon: const Icon(Icons.alarm_add_outlined), label: const Text("Definir Lembrete"))),

                  // TODO: Adicionar TabBar e TabBarView para as abas Cuidados, Diário, Lembretes
                  // Esta é uma simplificação para corrigir os erros de build.
                  // A estrutura completa com abas dentro de CustomScrollView é mais complexa.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mova _buildSectionTitle para cá
  Widget _buildSectionTitle(BuildContext context, String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color, // Usa a cor passada ou a padrão do tema
              fontWeight: FontWeight.w600
            ),
      ),
    );
  }
  // Implemente _buildCareTab, _buildDiaryTab, _buildRemindersTab aqui
  // usando _currentPlantData para os dados.
}