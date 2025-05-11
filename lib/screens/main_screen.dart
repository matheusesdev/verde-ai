// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'my_garden_screen.dart';
import 'identify_diagnose_screen.dart';
import 'community_screen.dart';
import '../models/plant_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Plant> _myPlantsList = [];

  void changeTab(int index) {
    if (index >= 0 && index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void addPlantToGardenAndNavigate(Plant plant, BuildContext passedContext) {
    bool plantExists = _myPlantsList.any((p) => p.id == plant.id);

    if (!plantExists) {
      setState(() {
        _myPlantsList.add(plant);
      });
      ScaffoldMessenger.of(passedContext).showSnackBar(
        SnackBar(content: Text('${plant.name} adicionada ao seu jardim!')),
      );
    } else {
       ScaffoldMessenger.of(passedContext).showSnackBar(
        SnackBar(content: Text('${plant.name} já está no seu jardim!')),
      );
    }
    // Navegar para detalhes mesmo que a planta já exista, para visualização
    Navigator.pushNamed(
      passedContext, // Usar o contexto correto
      '/plant_details',
      arguments: { // Passar como um Map
        'plant': plant, // O objeto Plant
        'updateCallback': updatePlantInGarden, // A função de callback
      }
    );
  }

  void updatePlantInGarden(Plant updatedPlant) {
    setState(() {
      final index = _myPlantsList.indexWhere((p) => p.id == updatedPlant.id);
      if (index != -1) {
        _myPlantsList[index] = updatedPlant;
      }
    });
  }

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
     _widgetOptions = <Widget>[
      DashboardScreen(myPlants: _myPlantsList, onNavigateToTab: changeTab),
      MyGardenScreen(
        myPlants: _myPlantsList,
        addPlantCallback: addPlantToGardenAndNavigate,
        updatePlantCallback: updatePlantInGarden,
      ),
      IdentifyDiagnoseScreen(addPlantCallback: addPlantToGardenAndNavigate),
      const CommunityScreen(),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined),
            activeIcon: Icon(Icons.local_florist),
            label: 'Meu Jardim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: 'Identificar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Comunidade',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}