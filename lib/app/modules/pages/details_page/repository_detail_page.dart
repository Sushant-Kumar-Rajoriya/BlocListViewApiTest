import 'package:flutter/material.dart';

import '../../../data/model/items_model.dart';

class RepositoryDetailPage extends StatelessWidget {
  final Item item;

  const RepositoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owner: ${item.owner.login}', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Description: ${item.description ?? 'No description'}'),
            const SizedBox(height: 8),
            Text('Stars: ${item.stargazersCount}'),
            const SizedBox(height: 8),
            Text('Forks: ${item.forksCount}'),
            const SizedBox(height: 8),
            Text('Open Issues: ${item.openIssuesCount}'),
            const SizedBox(height: 8),
            Text('Created At: ${item.createdAt}'),
            const SizedBox(height: 8),
            Text('Updated At: ${item.updatedAt}'),
            const SizedBox(height: 8),
            Text('Homepage: ${item.homepage ?? 'No homepage'}'),
            const SizedBox(height: 8),
            Text('Language: ${item.language ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Visibility: ${item.visibility}'),
          ],
        ),
      ),
    );
  }
}
