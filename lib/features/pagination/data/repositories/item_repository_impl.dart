import 'dart:math';
import '../models/item_model.dart';
import '../../domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  final List<ItemModel> _mockDatabase = List.generate(
    100,
    (index) => ItemModel(
      id: index + 1,
      title: 'Item ${index + 1}',
      description: 'This is a description for item ${index + 1}',
      imageUrl: 'https://picsum.photos/id/${(index % 50) + 1}/200/200',
    ),
  );

  @override
  Future<List<ItemModel>> getItems({required int page, required int limit}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, _mockDatabase.length);
    
    if (startIndex >= _mockDatabase.length) {
      return [];
    }
    
    return _mockDatabase.sublist(startIndex, endIndex);
  }

  @override
  Future<int> getTotalCount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDatabase.length;
  }
}
