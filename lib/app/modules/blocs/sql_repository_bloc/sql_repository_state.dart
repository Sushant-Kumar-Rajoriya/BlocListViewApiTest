import 'package:bloc_api_call_listview/app/data/model/items_model.dart';

abstract class SqlRepositoryState {}

class SqlRepositoryInitial extends SqlRepositoryState {}

class SqlRepositoryLoading extends SqlRepositoryState {}

class SqlRepositoryLoaded extends SqlRepositoryState {
  final List<Item> data;

  SqlRepositoryLoaded(this.data);
}

class SqlRepositoryError extends SqlRepositoryState {
  final String message;

  SqlRepositoryError(this.message);
}
class SqlRepositorySelected extends SqlRepositoryState {
  final List<Item> data;
  final Set<Item> selectedItems;

  SqlRepositorySelected(this.data, this.selectedItems);
}