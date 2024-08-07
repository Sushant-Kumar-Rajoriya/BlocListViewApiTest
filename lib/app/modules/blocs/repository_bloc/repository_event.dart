import 'package:bloc_api_call_listview/app/data/model/items_model.dart';
import 'package:equatable/equatable.dart';

abstract class RepositoryEvent extends Equatable {
  const RepositoryEvent();

  @override
  List<Object> get props => [];
}

class FetchRepositories extends RepositoryEvent {
  final String? date;
  final String? sort;
  final String? order;

  const FetchRepositories({this.date, this.sort, this.order});

  @override
  List<Object> get props => [date ?? '', sort ?? '', order ?? ''];
}

class SaveRepository extends RepositoryEvent {
  final Item repository;

  const SaveRepository(this.repository);

  @override
  List<Object> get props => [repository];
}

class SelectRepository extends RepositoryEvent {
  final Item repository;

  const SelectRepository(this.repository);

  @override
  List<Object> get props => [repository];
}

class DeselectRepository extends RepositoryEvent {
  final Item repository;

  const DeselectRepository(this.repository);

  @override
  List<Object> get props => [repository];
}

class SaveSelectedRepositories extends RepositoryEvent {
  const SaveSelectedRepositories();

  @override
  List<Object> get props => [];
}

class RefreshData extends RepositoryEvent {}