// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Para CupertinoIcons se você os usar na BottomNav
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import 'dashboard_screen.dart';
import 'my_garden_screen.dart';
import 'identify_diagnose_screen.dart';
import 'community_screen.dart';
import '../models/plant_model.dart'; // Necessário para a lista _myPlantsList e callbacks

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Função para mudar a aba programaticamente, passada para o DashboardScreen
  void _changeTab(int index) {
    if (index >= 0 && index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Callback para adicionar planta (vindo de IdentifyDiagnoseScreen) e navegar para detalhes
  void _addPlantToGardenAndNavigate(Plant plant, BuildContext passedContext) {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final existingPlant = plantProvider.getPlantById(plant.id);

    if (existingPlant == null) {
      plantProvider.addPlant(plant);
      if (mounted && passedContext.mounted) { // Verificar se os contextos ainda são válidos
        ScaffoldMessenger.of(passedContext).showSnackBar(
          SnackBar(content: Text('${plant.name} adicionada ao seu jardim!')),
        );
      }
    } else {
      if (mounted && passedContext.mounted) {
        ScaffoldMessenger.of(passedContext).showSnackBar(
          SnackBar(content: Text('${plant.name} já está no seu jardim!')),
        );
      }
    }
    // Navegar para detalhes mesmo que a planta já exista, para visualização
    // Passar o contexto que pode realizar a navegação (geralmente o da tela que chamou)
    Navigator.pushNamed(
      passedContext,
      '/plant_details',
      arguments: {
        'plant': plant,
        'updateCallback': _updatePlantInGarden, // Passar a função de update
      }
    );
  }

  // Callback para atualizar uma planta na lista (vindo de PlantDetailsScreen)
  void _updatePlantInGarden(Plant updatedPlant) {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    plantProvider.updatePlant(updatedPlant);
  }

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
     _widgetOptions = <Widget>[
      DashboardScreen(onNavigateToTab: _changeTab), // Passa a função _changeTab
      MyGardenScreen(
        addPlantCallback: _addPlantToGardenAndNavigate, // Este callback não é mais usado diretamente por MyGardenScreen
        updatePlantCallback: _updatePlantInGarden,
      ),
      IdentifyDiagnoseScreen(addPlantCallback: _addPlantToGardenAndNavigate), // Passa o callback correto
      const CommunityScreen(), // CommunityScreen pode ser const se não precisar de parâmetros do MainScreen
    ];
  }

  // Função chamada quando um item da BottomNavigationBar é tocado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _widgetOptions.length,
        child: IndexedStack( // Usar IndexedStack para preservar o estado das abas
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house), // Exemplo de ícone Cupertino
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tree), // Exemplo
            activeIcon: Icon(CupertinoIcons.leaf_arrow_circlepath), // Exemplo diferente para ativo
            label: 'Meu Jardim',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            activeIcon: Icon(CupertinoIcons.camera_fill),
            label: 'Identificar',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
            activeIcon: Icon(CupertinoIcons.group_solid),
            label: 'Comunidade',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // O tipo, cores, etc., já são definidos pelo BottomNavigationBarThemeData no tema global em main.dart
        // Mas você pode sobrescrever aqui se necessário:
        // type: BottomNavigationBarType.fixed,
        // selectedItemColor: Theme.of(context).primaryColor,
        // unselectedItemColor: Colors.grey,
      ),
    );
  }
}