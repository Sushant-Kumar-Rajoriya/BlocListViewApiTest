import 'package:bloc_api_call_listview/app/data/model/items_model.dart';

abstract class SqlRepositoryEvent {}

class LoadDataFromDb extends SqlRepositoryEvent {}

class SaveDataToDb extends SqlRepositoryEvent {
  final Item data;

  SaveDataToDb(this.data);
}

class RemoveRepositories extends SqlRepositoryEvent {
  final List<num> itemIds;

  RemoveRepositories(this.itemIds);
}

class SelectItem extends SqlRepositoryEvent {
  final Item item;

  SelectItem(this.item);
}

class DeselectItem extends SqlRepositoryEvent {
  final Item item;

  DeselectItem(this.item);
}

class ClearSelection extends SqlRepositoryEvent {}