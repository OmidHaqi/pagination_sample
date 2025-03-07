import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ViewType {
  grid,
  list
}

enum AnimationPreference {
  enabled,
  reduced,
  disabled
}

class UISettingsViewModel extends ChangeNotifier {
  // Default settings
  ThemeMode _themeMode = ThemeMode.system;
  ViewType _viewType = ViewType.grid;
  bool _compactView = false;
  int _gridColumns = 2;
  AnimationPreference _animationPreference = AnimationPreference.enabled;
  
  // Shared preferences keys
  static const String _themeModeKey = 'themeMode';
  static const String _viewTypeKey = 'viewType';
  static const String _compactViewKey = 'compactView';
  static const String _gridColumnsKey = 'gridColumns';
  static const String _animationPreferenceKey = 'animationPreference';
  
  // Constructor - load saved settings
  UISettingsViewModel() {
    _loadSettings();
  }

  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme mode
    final themeModeIndex = prefs.getInt(_themeModeKey);
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }
    
    // Load view type
    final viewTypeIndex = prefs.getInt(_viewTypeKey);
    if (viewTypeIndex != null) {
      _viewType = ViewType.values[viewTypeIndex];
    }
    
    // Load compact view
    final compactView = prefs.getBool(_compactViewKey);
    if (compactView != null) {
      _compactView = compactView;
    }
    
    // Load grid columns
    final gridColumns = prefs.getInt(_gridColumnsKey);
    if (gridColumns != null) {
      _gridColumns = gridColumns;
    }
    
    // Load animation preference
    final animationPrefIndex = prefs.getInt(_animationPreferenceKey);
    if (animationPrefIndex != null) {
      _animationPreference = AnimationPreference.values[animationPrefIndex];
    }
    
    // Notify listeners after loading all settings
    notifyListeners();
  }
  
  // Save settings to shared preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt(_themeModeKey, _themeMode.index);
    await prefs.setInt(_viewTypeKey, _viewType.index);
    await prefs.setBool(_compactViewKey, _compactView);
    await prefs.setInt(_gridColumnsKey, _gridColumns);
    await prefs.setInt(_animationPreferenceKey, _animationPreference.index);
  }
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  ViewType get viewType => _viewType;
  bool get compactView => _compactView;
  int get gridColumns => _gridColumns;
  AnimationPreference get animationPreference => _animationPreference;
  
  // Computed properties
  bool get isGridView => _viewType == ViewType.grid;
  bool get isListView => _viewType == ViewType.list;
  bool get areAnimationsEnabled => _animationPreference != AnimationPreference.disabled;
  double get animationsScale => _animationPreference == AnimationPreference.reduced ? 0.5 : 1.0;
  
  // Theme setters
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _saveSettings();
      notifyListeners();
    }
  }
  
  void toggleThemeMode() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    _saveSettings();
    notifyListeners();
  }
  
  // View type setters
  void setViewType(ViewType type) {
    if (_viewType != type) {
      _viewType = type;
      _saveSettings();
      notifyListeners();
    }
  }
  
  void toggleViewType() {
    _viewType = _viewType == ViewType.grid ? ViewType.list : ViewType.grid;
    _saveSettings();
    notifyListeners();
  }
  
  // Grid settings
  void setGridColumns(int columns) {
    if (columns >= 1 && columns <= 4 && _gridColumns != columns) {
      _gridColumns = columns;
      _saveSettings();
      notifyListeners();
    }
  }
  
  void incrementGridColumns() {
    if (_gridColumns < 4) {
      _gridColumns++;
      _saveSettings();
      notifyListeners();
    }
  }
  
  void decrementGridColumns() {
    if (_gridColumns > 1) {
      _gridColumns--;
      _saveSettings();
      notifyListeners();
    }
  }
  
  // Compact view setting
  void setCompactView(bool isCompact) {
    if (_compactView != isCompact) {
      _compactView = isCompact;
      _saveSettings();
      notifyListeners();
    }
  }
  
  void toggleCompactView() {
    _compactView = !_compactView;
    _saveSettings();
    notifyListeners();
  }
  
  // Animation settings
  void setAnimationPreference(AnimationPreference preference) {
    if (_animationPreference != preference) {
      _animationPreference = preference;
      _saveSettings();
      notifyListeners();
    }
  }
  
  // Default settings
  void resetToDefaults() {
    _themeMode = ThemeMode.system;
    _viewType = ViewType.grid;
    _compactView = false;
    _gridColumns = 2;
    _animationPreference = AnimationPreference.enabled;
    _saveSettings();
    notifyListeners();
  }
}
