import 'package:bloc_api_call_listview/app/data/model/items_model.dart';
import 'package:bloc_api_call_listview/app/modules/blocs/sql_repository_bloc/sql_repository_bloc.dart';
import 'package:bloc_api_call_listview/app/modules/blocs/sql_repository_bloc/sql_repository_event.dart';
import 'package:bloc_api_call_listview/app/modules/blocs/sql_repository_bloc/sql_repository_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SqlRepositoryBloc>().add(LoadDataFromDb());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Repositories'),
        actions: [
          BlocBuilder<SqlRepositoryBloc, SqlRepositoryState>(
            builder: (context, state) {
              if (state is SqlRepositorySelected &&
                  state.selectedItems.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      _removeSelectedItemsFromDb(context, state.selectedItems),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: BlocBuilder<SqlRepositoryBloc, SqlRepositoryState>(
        builder: (context, state) {
          if (state is SqlRepositoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else
          if (state is SqlRepositoryLoaded || state is SqlRepositorySelected) {
            final items = state is SqlRepositoryLoaded
                ? state.data
                : (state as SqlRepositorySelected).data;
            final selectedItems = state is SqlRepositorySelected ? state
                .selectedItems : <Item>{};

            return RefreshIndicator(
              onRefresh: () async {
                context.read<SqlRepositoryBloc>().add(LoadDataFromDb());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data Refreshing...')),
                );
              },
              child: ListView.builder(
            itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedItems.contains(item);

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.owner.avatarUrl),
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        if (value == true) {
                          context.read<SqlRepositoryBloc>().add(
                              SelectItem(item));
                        } else {
                          context.read<SqlRepositoryBloc>().add(
                              DeselectItem(item));
                        }
                      },
                    ),
                    title: Text(item.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Owner: ${item.owner.login}'),
                        const SizedBox(height: 4),
                        Text('Stars: ${item.stargazersCount}'),
                        const SizedBox(height: 4),
                        Text('Forks: ${item.forksCount}'),
                        const SizedBox(height: 4),
                        Text('Open Issues: ${item.openIssuesCount}'),
                        if (item.description != null) const SizedBox(height: 4),
                        if (item.description != null)
                          Text('Description: ${item.description}'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // Navigate to details page
                    },
                  ),
                );
              },
            ),
          );
          } else if (state is SqlRepositoryError) {
          return Center(child: Text(state.message));
          } else {
          return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Future<void> _removeSelectedItemsFromDb(BuildContext context,
      Set<Item> selectedItems) async {
    final selectedItemIds = selectedItems.map((item) => item.id).toList();
    context.read<SqlRepositoryBloc>().add(RemoveRepositories(selectedItemIds));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removing selected repositories...')),
    );
    context.read<SqlRepositoryBloc>().add(ClearSelection());
  }
}
