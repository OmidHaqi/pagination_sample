import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/ui_settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = Provider.of<UISettingsViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: Hero(
          tag: 'settings-icon',
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: IconButton(
              icon: const Icon(Icons.restore),
              tooltip: 'Reset to defaults',
              onPressed: () {
                _showResetConfirmation(context, settingsViewModel);
              },
            ),
          ),
        ],
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: ListView(
          children: [
            _buildAnimatedSection(
              context, 
              'Theme', 
              child: _buildThemeSettings(context, settingsViewModel),
              icon: Icons.palette_outlined,
              delay: const Duration(milliseconds: 100),
            ),
            
            const SizedBox(height: 8),
            
            _buildAnimatedSection(
              context, 
              'View Preferences',
              child: _buildViewSettings(context, settingsViewModel),
              icon: Icons.visibility_outlined,
              delay: const Duration(milliseconds: 200),
            ),
            
            const SizedBox(height: 8),
            
            _buildAnimatedSection(
              context, 
              'Animations',
              child: _buildAnimationSettings(context, settingsViewModel),
              icon: Icons.animation_outlined,
              delay: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResetConfirmation(BuildContext context, UISettingsViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton(
            child: const Text('RESET'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      viewModel.resetToDefaults();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Settings reset to defaults'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildAnimatedSection(
    BuildContext context, 
    String title, 
    {required Widget child, IconData? icon, Duration delay = Duration.zero}
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildSettingsSection(context, title, child: child, icon: icon),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, 
    String title, 
    {required Widget child, IconData? icon}
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon, 
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildThemeSettings(BuildContext context, UISettingsViewModel viewModel) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('Light Theme'),
          secondary: const Icon(Icons.light_mode),
          value: ThemeMode.light,
          groupValue: viewModel.themeMode,
          onChanged: (value) => viewModel.setThemeMode(value!),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark Theme'),
          secondary: const Icon(Icons.dark_mode),
          value: ThemeMode.dark,
          groupValue: viewModel.themeMode,
          onChanged: (value) => viewModel.setThemeMode(value!),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('System Theme'),
          secondary: const Icon(Icons.phone_android),
          value: ThemeMode.system,
          groupValue: viewModel.themeMode,
          onChanged: (value) => viewModel.setThemeMode(value!),
        ),
      ],
    );
  }
  
  Widget _buildViewSettings(BuildContext context, UISettingsViewModel viewModel) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        ListTile(
          title: const Text('View Type'),
          subtitle: const Text('Choose between grid or list view'),
          trailing: SegmentedButton<ViewType>(
            segments: const [
              ButtonSegment<ViewType>(
                value: ViewType.grid,
                icon: Icon(Icons.grid_view),
                label: Text('Grid'),
              ),
              ButtonSegment<ViewType>(
                value: ViewType.list,
                icon: Icon(Icons.view_list),
                label: Text('List'),
              ),
            ],
            selected: {viewModel.viewType},
            onSelectionChanged: (Set<ViewType> selected) {
              viewModel.setViewType(selected.first);
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Compact View'),
          subtitle: const Text('Use more compact spacing'),
          secondary: Icon(
            Icons.compress_outlined, 
            color: theme.colorScheme.onSurfaceVariant,
          ),
          value: viewModel.compactView,
          onChanged: (value) => viewModel.setCompactView(value),
        ),
        if (viewModel.isGridView) 
          ListTile(
            title: const Text('Grid Columns'),
            subtitle: Slider(
              min: 1,
              max: 4,
              divisions: 3,
              label: viewModel.gridColumns.toString(),
              value: viewModel.gridColumns.toDouble(),
              onChanged: (value) => viewModel.setGridColumns(value.toInt()),
            ),
            trailing: Chip(
              label: Text('${viewModel.gridColumns}'),
              backgroundColor: theme.colorScheme.secondaryContainer,
              labelStyle: TextStyle(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildAnimationSettings(BuildContext context, UISettingsViewModel viewModel) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        RadioListTile<AnimationPreference>(
          title: const Text('Full Animations'),
          subtitle: const Text('All animations enabled'),
          secondary: Icon(
            Icons.motion_photos_on, 
            color: theme.colorScheme.onSurfaceVariant,
          ),
          value: AnimationPreference.enabled,
          groupValue: viewModel.animationPreference,
          onChanged: (value) => viewModel.setAnimationPreference(value!),
        ),
        RadioListTile<AnimationPreference>(
          title: const Text('Reduced Animations'),
          subtitle: const Text('Simpler animations'),
          secondary: Icon(
            Icons.speed, 
            color: theme.colorScheme.onSurfaceVariant,
          ),
          value: AnimationPreference.reduced,
          groupValue: viewModel.animationPreference,
          onChanged: (value) => viewModel.setAnimationPreference(value!),
        ),
        RadioListTile<AnimationPreference>(
          title: const Text('No Animations'),
          subtitle: const Text('Animations disabled'),
          secondary: Icon(
            Icons.motion_photos_off, 
            color: theme.colorScheme.onSurfaceVariant,
          ),
          value: AnimationPreference.disabled,
          groupValue: viewModel.animationPreference,
          onChanged: (value) => viewModel.setAnimationPreference(value!),
        ),
      ],
    );
  }
}
