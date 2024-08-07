import 'items_model.dart';

class DataModel {
  DataModel({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  final int totalCount;
  final bool incompleteResults;
  final List<Item> items;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      totalCount: json['total_count'],
      incompleteResults: json['incomplete_results'],
      items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'incomplete_results': incompleteResults,
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}
