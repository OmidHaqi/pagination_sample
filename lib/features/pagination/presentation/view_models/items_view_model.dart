import 'package:flutter/foundation.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/repositories/item_repository.dart';

enum LoadingState { initial, loading, loaded, error }

class ItemsViewModel extends ChangeNotifier {
  final ItemRepository _repository = ItemRepositoryImpl();
  
  List<ItemModel> _items = [];
  int _currentPage = 1;
  int _totalItems = 0;
  final int _itemsPerPage = 10;
  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';
  bool _hasMoreItems = true;

  // Getters
  List<ItemModel> get items => _items;
  int get currentPage => _currentPage;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  bool get hasMoreItems => _hasMoreItems;
  
  // Initialize by loading the first page
  Future<void> init() async {
    await loadItems();
    await _getTotalCount();
  }
  
  Future<void> _getTotalCount() async {
    try {
      _totalItems = await _repository.getTotalCount();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to get total items: $e';
      notifyListeners();
    }
  }

  // Load items for the current page
  Future<void> loadItems() async {
    if (_loadingState == LoadingState.loading) return;
    
    _loadingState = LoadingState.loading;
    notifyListeners();
    
    try {
      final newItems = await _repository.getItems(
        page: _currentPage,
        limit: _itemsPerPage,
      );
      
      if (newItems.isEmpty) {
        _hasMoreItems = false;
      } else {
        _items.addAll(newItems);
      }
      
      _loadingState = LoadingState.loaded;
    } catch (e) {
      _loadingState = LoadingState.error;
      _errorMessage = 'Failed to load items: $e';
    }
    
    notifyListeners();
  }
  
  // Load the next page
  Future<void> loadNextPage() async {
    if (!_hasMoreItems || _loadingState == LoadingState.loading) return;
    
    _currentPage++;
    await loadItems();
  }
  
  // Go to a specific page
  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages || page == _currentPage) return;
    
    _currentPage = page;
    _items = [];
    _hasMoreItems = true;
    await loadItems();
  }
  
  // Refresh the data
  Future<void> refreshItems() async {
    _currentPage = 1;
    _items = [];
    _hasMoreItems = true;
    await loadItems();
    await _getTotalCount();
  }
}
