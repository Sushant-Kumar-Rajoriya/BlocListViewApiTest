import 'package:bloc_api_call_listview/app/data/model/items_model.dart';
import 'package:bloc_api_call_listview/app/modules/blocs/repository_bloc/repository_bloc.dart';
import 'package:bloc_api_call_listview/app/modules/blocs/repository_bloc/repository_event.dart';
import 'package:bloc_api_call_listview/app/modules/blocs/repository_bloc/repository_state.dart';
import 'package:bloc_api_call_listview/app/modules/pages/offline_page/views/offline_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../details_page/repository_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Repositories'),
        actions: [
          BlocBuilder<RepositoryBloc, RepositoryState>(
            builder: (context, state) {
              if (state is RepositorySelected && state.selectedItems.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    context.read<RepositoryBloc>().add(const SaveSelectedRepositories());
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.cloud_off),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OfflinePage(),
                      ),
                    );
                  },
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: BlocListener<RepositoryBloc, RepositoryState>(
        listener: (context, state) {
          if (state is RepositorySaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Repositories saved into SQLite!')),
            );
          }
        },
        child: BlocBuilder<RepositoryBloc, RepositoryState>(
          builder: (context, state) {
            if (state is RepositoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RepositorySaved) {
              context.read<RepositoryBloc>().add(const FetchRepositories());
              return const Center(child: CircularProgressIndicator());
            } else if (state is RepositoryLoaded || state is RepositorySelected) {
              final dataModel = state is RepositoryLoaded ? state.dataModel : (state as RepositorySelected).dataModel;
              final selectedItems = state is RepositorySelected ? state.selectedItems : <Item>{};
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RepositoryBloc>().add(const FetchRepositories());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Refreshing...')),
                  );
                },
                child: ListView.builder(
                  itemCount: dataModel.items.length,
                  itemBuilder: (context, index) {
                    final item = dataModel.items[index];
                    final isSelected = selectedItems.contains(item);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.owner.avatarUrl),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            if (value == true) {
                              context.read<RepositoryBloc>().add(SelectRepository(item));
                            } else {
                              context.read<RepositoryBloc>().add(DeselectRepository(item));
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RepositoryDetailPage(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (state is RepositoryError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }


  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const FilterBottomSheet();
      },
    );
  }
}
