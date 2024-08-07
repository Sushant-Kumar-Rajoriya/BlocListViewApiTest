import 'package:bloc_api_call_listview/app/data/provider/local/sql_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/items_model.dart';
import 'sql_repository_event.dart';
import 'sql_repository_state.dart';

class SqlRepositoryBloc extends Bloc<SqlRepositoryEvent, SqlRepositoryState> {
  final SqlRepository _sqlRepository;

  SqlRepositoryBloc(this._sqlRepository) : super(SqlRepositoryInitial()) {
    on<LoadDataFromDb>(_onLoadDataFromDb);
    on<SaveDataToDb>(_onSaveDataToDb);
    on<RemoveRepositories>(_onRemoveRepositories);
    on<SelectItem>(_onSelectItem);
    on<DeselectItem>(_onDeselectItem);
    on<ClearSelection>(_onClearSelection);
  }

  Future<void> _onLoadDataFromDb(LoadDataFromDb event, Emitter<SqlRepositoryState> emit) async {
    emit(SqlRepositoryLoading());
    try {
      final data = await _sqlRepository.getRepositories();
      emit(SqlRepositoryLoaded(data));
    } catch (e) {
      emit(SqlRepositoryError(e.toString()));
    }
  }

  Future<void> _onSaveDataToDb(SaveDataToDb event, Emitter<SqlRepositoryState> emit) async {
    emit(SqlRepositoryLoading());
    try {
      await _sqlRepository.insertData(event.data.toSqlJson());
      final data = await _sqlRepository.getRepositories();
      emit(SqlRepositoryLoaded(data));
    } catch (e) {
      emit(SqlRepositoryError(e.toString()));
    }
  }

  Future<void> _onRemoveRepositories(RemoveRepositories event, Emitter<SqlRepositoryState> emit) async {
    emit(SqlRepositoryLoading());
    try {
      await _sqlRepository.removeRepositories(event.itemIds);
      final data = await _sqlRepository.getRepositories();
      emit(SqlRepositoryLoaded(data));
    } catch (e) {
      emit(SqlRepositoryError(e.toString()));
    }
  }

  void _onSelectItem(SelectItem event, Emitter<SqlRepositoryState> emit) {
    if (state is SqlRepositoryLoaded) {
      final loadedState = state as SqlRepositoryLoaded;
      final Set<Item> selectedItems = {};
      selectedItems.add(event.item);
      emit(SqlRepositorySelected(loadedState.data, selectedItems));
    } else if (state is SqlRepositorySelected) {
      final selectedState = state as SqlRepositorySelected;
      final Set<Item> selectedItems = Set<Item>.from(selectedState.selectedItems);
      selectedItems.add(event.item);
      emit(SqlRepositorySelected(selectedState.data, selectedItems));
    }
  }

  void _onDeselectItem(DeselectItem event, Emitter<SqlRepositoryState> emit) {
    if (state is SqlRepositoryLoaded) {
      final loadedState = state as SqlRepositoryLoaded;
      final Set<Item> selectedItems = {};
      emit(SqlRepositorySelected(loadedState.data, selectedItems));
    } else if (state is SqlRepositorySelected) {
      final selectedState = state as SqlRepositorySelected;
      final Set<Item> selectedItems = Set<Item>.from(selectedState.selectedItems);
      selectedItems.remove(event.item);
      emit(SqlRepositorySelected(selectedState.data, selectedItems));
    }
  }

  void _onClearSelection(ClearSelection event, Emitter<SqlRepositoryState> emit) {
    if (state is SqlRepositoryLoaded) {
      final loadedState = state as SqlRepositoryLoaded;
      emit(SqlRepositorySelected(loadedState.data, {}));
    } else if (state is SqlRepositorySelected) {
      final selectedState = state as SqlRepositorySelected;
      emit(SqlRepositorySelected(selectedState.data, {}));
    }
  }

}
