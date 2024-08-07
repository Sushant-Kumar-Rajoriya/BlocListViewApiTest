import 'package:bloc_api_call_listview/app/data/model/items_model.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/data_model.dart';

abstract class RepositoryState extends Equatable {
  const RepositoryState();

  @override
  List<Object> get props => [];
}

class RepositoryInitial extends RepositoryState {}

class RepositoryLoading extends RepositoryState {}

class RepositoryLoaded extends RepositoryState {
  final DataModel dataModel;

  const RepositoryLoaded(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class RepositorySaving extends RepositoryState {}

class RepositorySaved extends RepositoryState {}

class RepositoryError extends RepositoryState {
  final String message;

  const RepositoryError(this.message);

  @override
  List<Object> get props => [message];
}

class RepositorySelected extends RepositoryState {
  final DataModel dataModel;
  final Set<Item> selectedItems;

  const RepositorySelected(this.dataModel, this.selectedItems);

  @override
  List<Object> get props => [dataModel, selectedItems];
}
