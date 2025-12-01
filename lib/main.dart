import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Clase para manejar el estado de temas
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.deepPurple;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );
}

/// App raíz con Material 3 y temas automáticos
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Hábitos & Objetivos',
          theme: _themeProvider.lightTheme,
          darkTheme: _themeProvider.darkTheme,
          themeMode: _themeProvider.themeMode,
          home: MainScreen(themeProvider: _themeProvider),
          // TODO: Integrar navegación avanzada con named routes
        );
      },
    );
  }
}

/// Pantalla principal con navegación por pestañas
class MainScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  
  const MainScreen({super.key, required this.themeProvider});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas para preservar el estado con IndexedStack
  List<Widget> get _screens => [
    const HomeScreen(),
    const GoalsScreen(),
    SettingsScreen(themeProvider: widget.themeProvider),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsivo: NavigationRail para pantallas anchas (>900px)
        final bool isWideScreen = constraints.maxWidth > 900;

        return Scaffold(
          body: isWideScreen
              ? Row(
                  children: [
                    // NavigationRail para escritorio/web
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _onItemTapped,
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Inicio'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.flag),
                          selectedIcon: Icon(Icons.flag),
                          label: Text('Objetivos'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Ajustes'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    // Contenido principal
                    Expanded(
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: _screens,
                      ),
                    ),
                  ],
                )
              : IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
          // NavigationBar para móvil
          bottomNavigationBar: isWideScreen
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Inicio',
                      tooltip: 'Hábitos del día',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.flag),
                      label: 'Objetivos',
                      tooltip: 'Objetivos a medio plazo',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings),
                      label: 'Ajustes',
                      tooltip: 'Configuración de la app',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// Pantalla de Inicio - Hábitos del día
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Rutina de gimnasio por día de la semana (1=Lunes, 7=Domingo)
  final Map<int, Map<String, dynamic>> _gymRoutines = {
    1: { // Lunes - Día 1: Pecho hombro tricep
      'title': 'Día 1: Pecho, Hombro y Trícep',
      'exercises': [
        'Press banca',
        'Press inclinado',
        'Aperturas',
        'Hombro lateral',
        'Trícep'
      ]
    },
    2: { // Martes - Día 2: espalda y bicep
      'title': 'Día 2: Espalda y Bícep',
      'exercises': [
        'Remo en barra o mancuerna',
        'Jalón al pecho',
        'Máquina de remo',
        'Bícep con mancuerna',
        'Bícep en máquina'
      ]
    },
    3: { // Miércoles - Día 3: pierna
      'title': 'Día 3: Pierna',
      'exercises': [
        'Sentadilla',
        'Extensión del cuádricep',
        'Máquina de femoral',
        'Aductor',
        'Gemelo'
      ]
    },
    4: { // Jueves - Día 4: pecho espalda
      'title': 'Día 4: Pecho y Espalda',
      'exercises': [
        'Press inclinado',
        'Press banca',
        'Aperturas',
        'Remo barra o mancuerna',
        'Jalón al pecho',
        'Máquina de remo'
      ]
    },
    5: { // Viernes - Día 5: brazo
      'title': 'Día 5: Brazo',
      'exercises': [
        'Press militar',
        'Hombro lateral',
        'Bícep martillo mancuerna',
        'Bícep máquina',
        'Trícep en polea alta',
        'Trícep en polea baja'
      ]
    },
    6: { // Sábado - Día 6: pierna (opcional)
      'title': 'Día 6: Pierna (Opcional)',
      'exercises': [
        'Sentadilla',
        'Extensión del cuádricep',
        'Máquina de femoral',
        'Aductor',
        'Gemelo'
      ]
    },
    7: { // Domingo - Descanso
      'title': 'Día de Descanso',
      'exercises': [
        'Descanso activo - Caminar',
        'Estiramientos',
        'Movilidad articular'
      ]
    }
  };

  // Lista de hábitos generales + ejercicios del día
  List<Map<String, dynamic>> _habits = [];
  final TextEditingController _newHabitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodaysRoutine();
  }

  void _loadTodaysRoutine() {
    // Obtener día de la semana actual (1=Lunes, 7=Domingo)
    final now = DateTime.now();
    final weekday = now.weekday;
    
    // Hábitos base
    final baseHabits = [
      {'name': 'Beber 8 vasos de agua', 'completed': false, 'type': 'habit'},
      {'name': 'Meditar 10 minutos', 'completed': false, 'type': 'habit'},
      {'name': 'Leer 20 páginas', 'completed': false, 'type': 'habit'},
    ];

    // Agregar ejercicios del día
    final todayRoutine = _gymRoutines[weekday];
    final exerciseHabits = todayRoutine?['exercises']?.map<Map<String, dynamic>>((exercise) => {
      'name': exercise,
      'completed': false,
      'type': 'exercise'
    }).toList() ?? [];

    setState(() {
      _habits = [...baseHabits, ...exerciseHabits];
    });
  }

  void _toggleHabit(int index) {
    setState(() {
      _habits[index]['completed'] = !_habits[index]['completed'];
    });
  }

  void _addNewHabit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Hábito'),
          content: TextField(
            controller: _newHabitController,
            decoration: const InputDecoration(
              labelText: 'Nombre del hábito',
              hintText: 'Ej: Tomar vitaminas',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _newHabitController.clear();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newHabitController.text.trim().isNotEmpty) {
                  setState(() {
                    _habits.add({
                      'name': _newHabitController.text.trim(),
                      'completed': false,
                      'type': 'custom'
                    });
                  });
                  Navigator.of(context).pop();
                  _newHabitController.clear();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  String _getTodayRoutineTitle() {
    final weekday = DateTime.now().weekday;
    return _gymRoutines[weekday]?['title'] ?? 'Rutina del día';
  }

  @override
  void dispose() {
    _newHabitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hábitos del Día'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del progreso
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTodayRoutineTitle(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _habits.where((h) => h['completed']).length /
                          _habits.length,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_habits.where((h) => h['completed']).length}/${_habits.length} hábitos completados',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mis Hábitos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            // Lista de hábitos
            Expanded(
              child: ListView.builder(
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return Semantics(
                    label: 'Hábito: ${habit['name']}',
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: habit['completed'],
                          onChanged: (_) => _toggleHabit(index),
                        ),
                        title: Text(
                          habit['name'],
                          style: TextStyle(
                            decoration: habit['completed']
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: habit['type'] == 'exercise' 
                            ? const Text('💪 Ejercicio') 
                            : habit['type'] == 'habit' 
                                ? const Text('🎯 Hábito') 
                                : const Text('➕ Personalizado'),
                        trailing: habit['completed']
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        onTap: () => _toggleHabit(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewHabit,
        tooltip: 'Agregar nuevo hábito',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Pantalla de Objetivos
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Datos simulados de progreso mensual y semanal
  final Map<String, Map<String, dynamic>> _monthlyProgress = {
    'Noviembre 2025': {
      'totalDays': 30,
      'completedDays': 18,
      'gymDays': 15,
      'habitDays': 22,
      'weeklyData': [
        {'week': 'Semana 1', 'completed': 4, 'total': 7},
        {'week': 'Semana 2', 'completed': 5, 'total': 7},
        {'week': 'Semana 3', 'completed': 6, 'total': 7},
        {'week': 'Semana 4', 'completed': 3, 'total': 7},
      ]
    },
    'Octubre 2025': {
      'totalDays': 31,
      'completedDays': 22,
      'gymDays': 18,
      'habitDays': 25,
      'weeklyData': [
        {'week': 'Semana 1', 'completed': 6, 'total': 7},
        {'week': 'Semana 2', 'completed': 5, 'total': 7},
        {'week': 'Semana 3', 'completed': 7, 'total': 7},
        {'week': 'Semana 4', 'completed': 4, 'total': 7},
      ]
    }
  };

  // Lista de objetivos a largo plazo
  final List<Map<String, dynamic>> _longTermGoals = [
    {
      'name': 'Completar 100 días de gym',
      'current': 68,
      'target': 100,
      'deadline': '2025-03-31',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Meditar 365 días seguidos',
      'current': 45,
      'target': 365,
      'deadline': '2025-12-31',
      'icon': Icons.self_improvement,
    },
    {
      'name': 'Leer 24 libros este año',
      'current': 14,
      'target': 24,
      'deadline': '2025-12-31',
      'icon': Icons.book,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildMonthlyView() {
    final currentMonth = 'Noviembre 2025';
    final data = _monthlyProgress[currentMonth]!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen mensual
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de $currentMonth',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard('Días Completados', '${data['completedDays']}/${data['totalDays']}', 
                      Icons.calendar_today, data['completedDays'] / data['totalDays']),
                  const SizedBox(height: 12),
                  _buildStatCard('Días de Gym', '${data['gymDays']}/${data['totalDays']}', 
                      Icons.fitness_center, data['gymDays'] / data['totalDays']),
                  const SizedBox(height: 12),
                  _buildStatCard('Días con Hábitos', '${data['habitDays']}/${data['totalDays']}', 
                      Icons.check_circle, data['habitDays'] / data['totalDays']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Progreso semanal
          Text(
            'Progreso Semanal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...data['weeklyData'].map<Widget>((week) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text('${week['completed']}'),
              ),
              title: Text(week['week']),
              subtitle: LinearProgressIndicator(
                value: week['completed'] / week['total'],
              ),
              trailing: Text(
                '${week['completed']}/${week['total']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )).toList(),
          const SizedBox(height: 16),
          // Objetivos a largo plazo
          Text(
            'Objetivos a Largo Plazo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ..._longTermGoals.map((goal) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(goal['icon'], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          goal['name'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: goal['current'] / goal['target'],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${goal['current']}/${goal['target']}'),
                      Text('Meta: ${goal['deadline']}'),
                    ],
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, double progress) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: progress),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildWeeklyView() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Esta Semana',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Calendario semanal
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final date = startOfWeek.add(Duration(days: index));
                      final isToday = date.day == now.day;
                      final isCompleted = index < 4; // Simulado
                      
                      return Column(
                        children: [
                          Text(['L', 'M', 'X', 'J', 'V', 'S', 'D'][index]),
                          const SizedBox(height: 8),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: isToday 
                                ? Theme.of(context).colorScheme.primary
                                : isCompleted 
                                    ? Colors.green 
                                    : Theme.of(context).colorScheme.outline,
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isToday || isCompleted ? Colors.white : null,
                                fontWeight: isToday ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 16,
                            color: isCompleted ? Colors.green : Colors.grey,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Estadísticas de la semana
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estadísticas Semanales',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard('Días Gym Completados', '4/5', Icons.fitness_center, 0.8),
                  const SizedBox(height: 12),
                  _buildStatCard('Hábitos Diarios', '5/7', Icons.track_changes, 0.71),
                  const SizedBox(height: 12),
                  _buildStatCard('Consistencia', '85%', Icons.trending_up, 0.85),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso & Objetivos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Semanal', icon: Icon(Icons.calendar_view_week)),
            Tab(text: 'Mensual', icon: Icon(Icons.calendar_month)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWeeklyView(),
          _buildMonthlyView(),
        ],
      ),
    );
  }
}

/// Pantalla de Ajustes
class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  
  const SettingsScreen({super.key, required this.themeProvider});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _weeklyReportsEnabled = true;
  
  // Colores disponibles para temas
  final List<Map<String, dynamic>> _themeColors = [
    {'name': 'Púrpura', 'color': Colors.deepPurple, 'icon': Icons.palette},
    {'name': 'Verde Pistacho', 'color': const Color(0xFF8BC34A), 'icon': Icons.eco},
    {'name': 'Azul', 'color': Colors.blue, 'icon': Icons.water_drop},
    {'name': 'Naranja', 'color': Colors.deepOrange, 'icon': Icons.sunny},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // Configuración de tema
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Modo de Tema'),
                    subtitle: Text(_getThemeModeText()),
                    onTap: _showThemeModeDialog,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('Color del Tema'),
                    subtitle: const Text('Selecciona el color principal'),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.themeProvider.seedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: _showColorDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Configuración de notificaciones
            Card(
              child: Column(
                children: [
                  Semantics(
                    label: 'Activar notificaciones',
                    child: SwitchListTile(
                      title: const Text('Notificaciones'),
                      subtitle: const Text('Recibir recordatorios de hábitos'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        // TODO: Implementar lógica de notificaciones
                      },
                      secondary: const Icon(Icons.notifications),
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: 'Activar reportes semanales',
                    child: SwitchListTile(
                      title: const Text('Reportes Semanales'),
                      subtitle: const Text('Recibir resumen semanal de progreso'),
                      value: _weeklyReportsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _weeklyReportsEnabled = value;
                        });
                        // TODO: Implementar reportes semanales
                      },
                      secondary: const Icon(Icons.analytics),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Información de la app
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Acerca de'),
                    subtitle: const Text('Versión 1.0.0'),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Hábitos & Objetivos',
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'App para seguimiento de hábitos y objetivos',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Ayuda'),
                    subtitle: const Text('Cómo usar la aplicación'),
                    onTap: () {
                      // TODO: Navegar a pantalla de ayuda
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('TODO: Pantalla de ayuda')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeText() {
    switch (widget.themeProvider.themeMode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Automático';
    }
  }

  void _showThemeModeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Modo de Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeModeOption('Automático (Sistema)', ThemeMode.system, Icons.brightness_auto),
              _buildThemeModeOption('Claro', ThemeMode.light, Icons.light_mode),
              _buildThemeModeOption('Oscuro', ThemeMode.dark, Icons.dark_mode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeModeOption(String title, ThemeMode mode, IconData icon) {
    final isSelected = widget.themeProvider.themeMode == mode;
    
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        widget.themeProvider.setThemeMode(mode);
        Navigator.of(context).pop();
      },
    );
  }

  void _showColorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Color del Tema'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _themeColors.length,
              itemBuilder: (context, index) {
                final themeColor = _themeColors[index];
                final isSelected = widget.themeProvider.seedColor == themeColor['color'];
                
                return InkWell(
                  onTap: () {
                    widget.themeProvider.setSeedColor(themeColor['color']);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeColor['color'],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          themeColor['icon'],
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          themeColor['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check, color: Colors.white, size: 16),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
