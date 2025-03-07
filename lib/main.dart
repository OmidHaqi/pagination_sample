import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/pagination/presentation/view_models/items_view_model.dart';
import 'features/pagination/presentation/view_models/ui_settings_view_model.dart';
import 'features/pagination/presentation/screens/items_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemsViewModel()),
        ChangeNotifierProvider(create: (_) => UISettingsViewModel()),
      ],
      child: Consumer<UISettingsViewModel>(
        builder: (context, uiSettings, _) {
          return MaterialApp(
            title: 'Flutter Pagination Example',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: uiSettings.themeMode,

            home: const ItemsScreen(),
          );
        },
      ),
    );
  }
}
