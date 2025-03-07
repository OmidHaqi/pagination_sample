import '../../data/models/item_model.dart';

abstract class ItemRepository {
  Future<List<ItemModel>> getItems({required int page, required int limit});
  Future<int> getTotalCount();
}
