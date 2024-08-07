import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/items_model.dart';
import '../../../data/provider/local/sql_repository.dart';
import '../../../data/repository/git_repository.dart';
import 'repository_event.dart';
import 'repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final GitRepository gitRepository;
  final SqlRepository sqlRepository;

  RepositoryBloc(this.gitRepository, this.sqlRepository)
      : super(RepositoryInitial()) {
    on<FetchRepositories>(_onFetchRepositories);
    on<SaveRepository>(_onSaveRepository);
    on<SelectRepository>(_onSelectRepository);
    on<DeselectRepository>(_onDeselectRepository);
    on<SaveSelectedRepositories>(_onSaveSelectedRepositories);
  }

  Future<void> _onFetchRepositories(
      FetchRepositories event, Emitter<RepositoryState> emit) async {
    emit(RepositoryLoading());
    try {
      final repositories = await gitRepository.fetchRepositories(
        date: event.date,
        sort: event.sort,
        order: event.order,
      );
      emit(RepositoryLoaded(repositories));
    } catch (e) {
      emit(RepositoryError(e.toString()));
    }
  }

  Future<void> _onSaveRepository(
      SaveRepository event, Emitter<RepositoryState> emit) async {
    emit(RepositorySaving());
    try {
      await sqlRepository.insertData(event.repository.toSqlJson());
      emit(RepositorySaved());
    } catch (e) {
      emit(RepositoryError(e.toString()));
    }
  }

  void _onSelectRepository(
      SelectRepository event, Emitter<RepositoryState> emit) {
    final currentState = state;
    if (currentState is RepositoryLoaded ||
        currentState is RepositorySelected) {
      final dataModel = currentState is RepositoryLoaded
          ? currentState.dataModel
          : (currentState as RepositorySelected).dataModel;
      final selectedItems = (currentState is RepositorySelected
              ? currentState.selectedItems
              : <Item>{})
          .toSet();
      selectedItems.add(event.repository);
      emit(RepositorySelected(dataModel, selectedItems));
    }
  }

  void _onDeselectRepository(
      DeselectRepository event, Emitter<RepositoryState> emit) {
    final currentState = state;
    if (currentState is RepositorySelected) {
      final dataModel = currentState.dataModel;
      final selectedItems = Set<Item>.from(currentState.selectedItems);
      selectedItems.remove(event.repository);
      emit(RepositorySelected(dataModel, selectedItems));
    }
  }

  Future<void> _onSaveSelectedRepositories(
      SaveSelectedRepositories event, Emitter<RepositoryState> emit) async {
    final currentState = state;
    if (currentState is RepositorySelected) {
      emit(RepositorySaving());
      try {
        for (var repository in currentState.selectedItems) {
          await sqlRepository.insertData(repository.toSqlJson());
        }
        emit(RepositorySaved());
      } catch (e) {
        emit(RepositoryError(e.toString()));
      }
    }
  }

}
