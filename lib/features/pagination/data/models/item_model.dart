class ItemModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
