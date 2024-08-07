import 'dart:async';

import 'package:bloc_api_call_listview/app/data/model/items_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlRepository {
  static final SqlRepository _instance = SqlRepository._internal();

  factory SqlRepository() {
    return _instance;
  }

  SqlRepository._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'repositories.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS repositories (
            id INTEGER PRIMARY KEY,
            node_id TEXT,
            name TEXT,
            full_name TEXT,
            private INTEGER,
            owner TEXT,
            html_url TEXT,
            description TEXT,
            fork INTEGER,
            url TEXT,
            forks_url TEXT,
            keys_url TEXT,
            collaborators_url TEXT,
            teams_url TEXT,
            hooks_url TEXT,
            issue_events_url TEXT,
            events_url TEXT,
            assignees_url TEXT,
            branches_url TEXT,
            tags_url TEXT,
            blobs_url TEXT,
            git_tags_url TEXT,
            git_refs_url TEXT,
            trees_url TEXT,
            statuses_url TEXT,
            languages_url TEXT,
            stargazers_url TEXT,
            contributors_url TEXT,
            subscribers_url TEXT,
            subscription_url TEXT,
            commits_url TEXT,
            git_commits_url TEXT,
            comments_url TEXT,
            issue_comment_url TEXT,
            contents_url TEXT,
            compare_url TEXT,
            merges_url TEXT,
            archive_url TEXT,
            downloads_url TEXT,
            issues_url TEXT,
            pulls_url TEXT,
            milestones_url TEXT,
            notifications_url TEXT,
            labels_url TEXT,
            releases_url TEXT,
            deployments_url TEXT,
            created_at TEXT,
            updated_at TEXT,
            pushed_at TEXT,
            git_url TEXT,
            ssh_url TEXT,
            clone_url TEXT,
            svn_url TEXT,
            homepage TEXT,
            size INTEGER,
            stargazers_count INTEGER,
            watchers_count INTEGER,
            language TEXT,
            has_issues INTEGER,
            has_projects INTEGER,
            has_downloads INTEGER,
            has_wiki INTEGER,
            has_pages INTEGER,
            has_discussions INTEGER,
            forks_count INTEGER,
            mirror_url TEXT,
            archived INTEGER,
            disabled INTEGER,
            open_issues_count INTEGER,
            license TEXT,
            allow_forking INTEGER,
            is_template INTEGER,
            web_commit_signoff_required INTEGER,
            topics TEXT,
            visibility TEXT,
            forks INTEGER,
            open_issues INTEGER,
            watchers INTEGER,
            default_branch TEXT,
            score REAL
          );
        ''');
      },
    );
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    await _database?.insert('repositories', data);
  }

  Future<List<Item>> getRepositories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('repositories');
    return List.generate(maps.length, (i) {
      return Item.fromSqlJson(maps[i]);
    });
  }

  Future<void> removeRepositories(List<num> ids) async {
    final db = await database;
    await db.delete(
      'repositories',
      where: 'id IN (${ids.join(', ')})',
    );
  }
}
