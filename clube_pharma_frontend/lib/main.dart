import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/treatment_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/appointment_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar estilo da barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TreatmentProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: const ClubePharmaApp(),
    ),
  );
}

class ClubePharmaApp extends StatefulWidget {
  const ClubePharmaApp({super.key});

  @override
  State<ClubePharmaApp> createState() => _ClubePharmaAppState();
}

class _ClubePharmaAppState extends State<ClubePharmaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClubePharma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      builder: (context, child) {
        return ThemeSwitcherProvider(toggleTheme: _toggleTheme, child: child!);
      },
    );
  }
}

class ThemeSwitcherProvider extends InheritedWidget {
  final VoidCallback toggleTheme;

  const ThemeSwitcherProvider({
    super.key,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeSwitcherProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeSwitcherProvider>();
  }

  @override
  bool updateShouldNotify(ThemeSwitcherProvider oldWidget) => false;
}
