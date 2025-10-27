import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/clube_pharma_logo.dart';
import '../main.dart';
import 'tabs/inicio_tab.dart';
import 'tabs/consultas_tab.dart';
import 'tabs/farmacia_tab_integrated.dart';
import 'tabs/tratamentos_tab.dart';
import 'tabs/familia_tab.dart';
import 'tabs/perfil_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<String> _tabLabels = [
    'Início',
    'Consultas',
    'Farmácia',
    'Meds',
    'Família',
    'Perfil',
  ];

  final List<IconData> _tabIcons = [
    Icons.home_rounded,
    Icons.medical_services_rounded,
    Icons.local_pharmacy_rounded,
    Icons.favorite_rounded,
    Icons.people_rounded,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Header fixo compacto
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  const ClubePharmaLogo(size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'ClubePharma',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      size: 20,
                    ),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      ThemeSwitcherProvider.of(context)?.toggleTheme();
                    },
                  ),
                  IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          size: 20,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      size: 20,
                    ),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo das tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                InicioTab(),
                ConsultasTab(),
                FarmaciaTabIntegrated(),
                TratamentosTab(),
                FamiliaTab(),
                PerfilTab(),
              ],
            ),
          ),

          // Bottom Navigation Bar - Estilo Mobile Moderno
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_tabLabels.length, (index) {
                    final isSelected = _currentIndex == index;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          _tabController.animateTo(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _tabIcons[index],
                                size: 24,
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _tabLabels[index],
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
